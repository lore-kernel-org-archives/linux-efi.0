From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 4/9] KEYS: Allow unrestricted boot-time addition of keys
 to secondary keyring
Date: Mon, 21 Nov 2016 09:04:55 -0500
Message-ID: <1479737095.2487.34.camel@linux.vnet.ibm.com>
References: <20161117064100.hmjmfw42ytm526yh@p310>
         <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
         <147931987366.16460.12891767069975068260.stgit@warthog.procyon.org.uk>
         <26349.1479376560@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <26349.1479376560-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Petko Manolov <petkan-5DSaK1yNf91Wk0Htik3J/w@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ima-devel <linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2016-11-17 at 09:56 +0000, David Howells wrote:
> Petko Manolov <petkan-5DSaK1yNf91Wk0Htik3J/w@public.gmane.org> wrote:
> 
> > On 16-11-16 18:11:13, David Howells wrote:
> > > Allow keys to be added to the system secondary certificates keyring during 
> > > kernel initialisation in an unrestricted fashion.  Such keys are implicitly 
> > > trusted and don't have their trust chains checked on link.
> > 
> > Well, I for one do not explicitly trust these keys.  I may even want to 
> > completely remove or replace them.
> 
> Fine be me.  However, if you remove them all I would guess that you cannot
> perform a secure boot.
> 
> Note that it's to be expected that the keys being loaded from the UEFI
> database cannot have their signatures checked - which is why they would have
> to be implicitly trusted.  For the same reason, the kernel does not check the
> signatures on the keys compiled into the kernel image.

Sigh, we've been here before, discussed this before.  Different keys
should be trusted at different levels.  Nothing has changed.  Just
because I trust a key in UEFI for UEFI, doesn't mean that I trust that
same key once the kernel has booted.

This time not only are you bringing the keys from UEFI up to the kernel,
but by adding these keys to the secondary trusted keyring, they are
allowed to add other keys they've signed to the secondary trusted
keyring.

If the UEFI keys are just for verifying kernel modules, why not define a
separate UEFI keyring, which can be used, if enabled, just for verifying
kernel modules, instead of affecting all signature verification?

IMA's root of trust goes back to UEFI, but transitions to the builtin
kernel keyring and, if enabled,  the secondary keyring on boot.

> > > This allows keys in the UEFI database to be added in secure boot mode for
> > > the purposes of module signing.
> > 
> > The key import should not be automatic, it should be optional.
> 
> You can argue this either way.  There's a config option to allow you to turn
> this on or off.  Arguably, this should be split in two: one for the whitelist
> (db, MokListRT) and one for the blacklist (dbx).

By "config", you're not referring to a Kconfig option, but a UEFI db
option, making it hidden/unknown to someone building a kernel.  If you
really want to add this support, make it clear and easily seen by
defining a "restrict_link_by_builtin_or_uefi" function.

Mimi

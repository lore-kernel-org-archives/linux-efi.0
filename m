From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/9] KEYS: Allow unrestricted boot-time addition of keys to secondary keyring
Date: Thu, 17 Nov 2016 11:18:31 +0000
Message-ID: <27878.1479381511@warthog.procyon.org.uk>
References: <20161117102205.hoypgpq5hfw6z2w7@p310> <20161117064100.hmjmfw42ytm526yh@p310> <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk> <147931987366.16460.12891767069975068260.stgit@warthog.procyon.org.uk> <26349.1479376560@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161117102205.hoypgpq5hfw6z2w7@p310>
Content-ID: <27877.1479381511.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petko Manolov <petkan-5DSaK1yNf91Wk0Htik3J/w@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Petko Manolov <petkan-5DSaK1yNf91Wk0Htik3J/w@public.gmane.org> wrote:

> > > Well, I for one do not explicitly trust these keys.  I may even want to 
> > > completely remove or replace them.
> > 
> > Fine be me.  However, if you remove them all I would guess that you cannot 
> > perform a secure boot.
> 
> Maybe not on PC, but there's plenty of other architectures out there.  What
> if i replace all UEFI keys with my own?

Then I would imagine that you can do a secure boot, but that you have to sign
your own shim, grub, kernel, etc..

> > Note that it's to be expected that the keys being loaded from the UEFI
> > database cannot have their signatures checked - which is why they would
> > have to be implicitly trusted.  For the same reason, the kernel does not
> > check the signatures on the keys compiled into the kernel image.
> 
> I build all kernels that matter to me and i _do_ trust myself.
> Unfortunately i can't say the same for any corporation out there.
> 
> Trusting a key because your vendor shipped the HW with it so that you have no 
> way to verify the signature is pretty weak argument IMHO.

I'm not making an argument there.  There is a reason I think that I can't
check them.  Well, possibly I could *if* those keys are actually signed *and*
I have certs built into the kernel by which I can verify all those keys in
UEFI variables.  I don't know whether this is actually practical.

> > You can argue this either way.  There's a config option to allow you to
> > turn this on or off.  Arguably, this should be split in two: one for the
> > whitelist (db, MokListRT) and one for the blacklist (dbx).
> 
> I did not see the config option.  There is one?

See patch 8 where these variables are actually parsed.  CONFIG_LOAD_UEFI_KEYS
is available there.

David

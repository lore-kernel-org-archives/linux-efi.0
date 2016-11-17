From: Petko Manolov <petkan-5DSaK1yNf91Wk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/9] KEYS: Allow unrestricted boot-time addition of keys
 to secondary keyring
Date: Thu, 17 Nov 2016 12:22:05 +0200
Message-ID: <20161117102205.hoypgpq5hfw6z2w7@p310>
References: <20161117064100.hmjmfw42ytm526yh@p310>
 <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
 <147931987366.16460.12891767069975068260.stgit@warthog.procyon.org.uk>
 <26349.1479376560@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <26349.1479376560-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16-11-17 09:56:00, David Howells wrote:
> Petko Manolov <petkan-5DSaK1yNf91Wk0Htik3J/w@public.gmane.org> wrote:
> 
> > On 16-11-16 18:11:13, David Howells wrote:
> > > Allow keys to be added to the system secondary certificates keyring during 
> > > kernel initialisation in an unrestricted fashion.  Such keys are 
> > > implicitly trusted and don't have their trust chains checked on link.
> > 
> > Well, I for one do not explicitly trust these keys.  I may even want to 
> > completely remove or replace them.
> 
> Fine be me.  However, if you remove them all I would guess that you cannot 
> perform a secure boot.

Maybe not on PC, but there's plenty of other architectures out there.  What if i 
replace all UEFI keys with my own?

> Note that it's to be expected that the keys being loaded from the UEFI 
> database cannot have their signatures checked - which is why they would have 
> to be implicitly trusted.  For the same reason, the kernel does not check the 
> signatures on the keys compiled into the kernel image.

I build all kernels that matter to me and i _do_ trust myself.  Unfortunately i 
can't say the same for any corporation out there.

Trusting a key because your vendor shipped the HW with it so that you have no 
way to verify the signature is pretty weak argument IMHO.

However, I am also well aware that most people just don't care. :)

> > > This allows keys in the UEFI database to be added in secure boot mode for 
> > > the purposes of module signing.
> > 
> > The key import should not be automatic, it should be optional.
> 
> You can argue this either way.  There's a config option to allow you to turn 
> this on or off.  Arguably, this should be split in two: one for the whitelist 
> (db, MokListRT) and one for the blacklist (dbx).

I did not see the config option.  There is one?

Right now i can't decide whether whitelist should go along with blacklist or 
there should be separate options.  I guess for whoever goes down this path it 
would make sense to use either both or none of them.

> Further, possibly I should add an option that allows this to be restricted to
> secure boot mode only.

Please do.  It doesn't make much sense otherwise.

> > Same applies to the validation process.
> 
> Depends what you mean by "the validation process"?  The use of secure boot at 
> all?  The checking of signatures on keys?  Module signing?

Nevermind.  The keys signature can't be verified in the classic UEFI case.


		Petko

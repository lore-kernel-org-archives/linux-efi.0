From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Capsule update support
Date: Thu, 16 Oct 2014 17:15:07 +0100
Message-ID: <20141016161507.GJ14343@console-pimps.org>
References: <CAGBcZGfHX57jwCfw7CnvLgOJ58kd0KVJULOvhAsfi=3YBp5WsQ@mail.gmail.com>
 <20141013095310.GZ14343@console-pimps.org>
 <CAGBcZGe=HszCxQyx8bBDUEQcF4g+gcMyLfGiM4dVz4=TfxvLpg@mail.gmail.com>
 <CAGBcZGfSdYa2yXW68RbywzCiC7mTxjAdGjUnwnhjWAwXZ0uqiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGBcZGfSdYa2yXW68RbywzCiC7mTxjAdGjUnwnhjWAwXZ0uqiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 14 Oct, at 06:30:22PM, Sam Protsenko wrote:
> Matt,
> 
> I tried to play with your code and now I have some extra notes about this patch:
> 
> 1. As it was proposed earlier, I support thought that it would be nice to
>    rename function names in next way:
> 
>      efi_update_capsule -> __efi_update_capsule
>      efi_capsule_update -> efi_update_capsule
> 
>    because it's quite confusing to have both efi_update_capsule() and
>    efi_capsule_update(). Besides, EFI function called UpdateCapsule, so it's
>    good idea to stick to this name in kernel API (I mean exporting
>    efi_update_capsule() instead of efi_capsule_update()).
 
I'm not so convinced by that argument. Remember, we're building a kernel
API here, so we've got functions like,

  efi_capsule_supported()
  efi_capsule_pending()

I've stuck with efi_capsule_update() and __efi_capsule_update() for now,
to continue the efi_capsule* theme (avoiding both efi_capsule_update()
and efi_update_capsule() was a good point though).

> 2. UEFI's UpdateCapsule() runtime service supports passing more than one
>    capsule to it (we can pass CapsuleCount argument to it for this purpose).
>    But your particular kernel implementation allows us only to provide one
>    capsule at a time. Is that was done for a reason? Can it be consider as
>    shortcoming?
 
Yeah, the reason is simply that it makes the capsule management more
complicated if you have more than one capsule, and when testing the
patches (and experimenting with the features in the capsule-* branches
in my git tree) I didn't come across a scenario where sending multiple
capsules at one time was required.

Doesn't mean we couldn't extend the kernel API in the future, though.
We'd just need an in-kernel user first.

> 3. I noticed that you dropped efi_capsule_build() in this patch (w.r.t.
>    https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/
>    implementation). BTW, it should be declared in header there.
>    Anyway, how do we suppose to build capsule to pass to efi_capsule_update()?
>    I mean, it can take a quite large code to build a capsule (allocating pages
>    etc). Wouldn't it be easier to user to use your API if it has something
>    ready to use? Anyway, if it should be done like this, it would be nice
>    to have a decent example code (use-case) how to use this API (maybe in
>    Documentation/, idk), because it looks quite non-intuitive (for me at least).
 
The two patches that I sent are only preparatory patches for EFI capsule
support, and Kweh (Cc'd) is working on patches that implement a userland
interface.

Wilson, do you think you could post your patches by the beginning of
next week? They just need to give an idea of how we can use this API. 

> 4. Tedious stuff: I checked your patch with "checkpatch.pl" and it shows
>     some warnings, please fix them if possible.

Will do.

> I will try to test and verify this patch further, will notify you if
> notice any issues.

Great, thanks.

-- 
Matt Fleming, Intel Open Source Technology Center

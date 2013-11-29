From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
Date: Fri, 29 Nov 2013 12:50:29 +0100
Message-ID: <20131129115029.GB4266@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-7-git-send-email-dyoung@redhat.com>
 <20131127114402.GB32267@pd.tnic>
 <20131129094034.GI4186@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131129094034.GI4186-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 29, 2013 at 05:40:35PM +0800, Dave Young wrote:
> Matt are suggesting to below one, is it ok to you? I'm fine with both.
>
> The efi runtime services can only be switched to virtual mode once
> without rebooting. The kexec kernel must maintain the same physical
> to virtual address mappings as the first kernel. The mappings are
> exported to sysfs so userspace tools can reassemble them and pass them
> into the kexec kernel.

His is explaining it better so take his :)

> Is it always 4K, how about "in pages"?

Actually no, so "in pages" is better.

> Since we do not know the exact number of ranges, introducing a list
> or count the totoal range numbers before will add more code. Do you
> really think it's necessary?
>
> I tend to not fix every warnings from checkpatch if it's not a
> must-fix one.

No need for the list - I actually meant you simply use a tmp pointer for
each krealloc invocation - just look around the tree for examples.

Also think about what happens to the pointed-to memory when krealloc
returns NULL.

> suppose kexec runtime map preparing fails we still can get 1st kernel
> boot ok.

Yeah, nothing stops that - especially if you iterate over the mapped
regions a second time separately, for kexec.

Which reminds me, all that save_runtime_map code needs to be behind
CONFIG_KEXEC. We don't want to be doing this if KEXEC is not enabled.

> > What would be much cleaner IMO would be if you let efi_map_regions()
> > finish, *and*, *only* if it was successful iterate again over the
> > regions and do efi_save_runtime_map() on the runtime ones. This will
> > make the code much more readable too.
> 
> For simplifying the code, will do.

Right, and hide it behind CONFIG_KEXEC too, while you're at it.

> I did not add KEXEC because I thought it can be used for debugging
> purpose.

mfleming is thinking about it :)

> Will check and update, what tree are you using?

Always current Linus tree and tip/master. This helps catch issues like
that.

> Hmm, it's created in efi.c so I think we can not move it..

Ok, so we apparently export naked kobjects like that. All right, fair
enough.

...

> Thanks for catching, actually I have changed it in my local tree since
> your last comment about other file.

:)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

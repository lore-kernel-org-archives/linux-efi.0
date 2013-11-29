From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Date: Fri, 29 Nov 2013 17:46:32 +0100
Message-ID: <20131129164632.GD4266@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-8-git-send-email-dyoung@redhat.com>
 <20131127140732.GD32267@pd.tnic>
 <20131129091415.GH4186@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131129091415.GH4186-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: toshi.kani-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 29, 2013 at 05:14:16PM +0800, Dave Young wrote:
> That's reserved for future extension use, who knows if we will need to
> pass other fields in the future.

Hrrmmm, 8*64 = 64 Bytes?? And you can't change it later because of the
situation where machines might be using older kexec-tools?

> > Static function - no need for "efi_" prefix.
> 
> Ok. I'm not very satisfied with the function name, any better
> suggestion?
> 
> reuse_config
> use_old_config_phys_addr
> update_config_entry_with_phys_addr

Looks like we're applying quirks so apply_quirks()?

And those kexec-specific quirks need to be behind CONFIG_KEXEC too, btw.

> Since Matt suggest to extend the function for other possible field
> other than smbios, so I would like to move comment to the front
> of the function like below:
> /*
>  * For kexec kernel there's some special config table entries which will be
>  * converted to virtual addresses after entering virtual mode. In kexec kernel
>  * we need the physical addresses instead, thus passing them via setup_data
>  * and update the entries to physical addresses in this function.
>  *
>  * Currently only handles smbios which is necessary for HP z420.
>  */

That's better.

> Is there any idea in your mind how to add the code for HP only?

DMI?

> Yes, __map_region return an error code will be better. Will you send
> a patch for __map_region? or I can add one more patch along with next
> version.

I was going to wait for your patches to settle down first so that I
don't disturb your work.

But if you want to fix this, I certainly wouldn't want to stop you :)
but please do so in a prepatch before your series which addresses only
this issue.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

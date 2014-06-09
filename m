From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86/boot: EFI_MIXED should not prohibit loading above 4G
Date: Mon, 9 Jun 2014 15:25:59 +0100
Message-ID: <20140609142559.GE27302@console-pimps.org>
References: <1402140380-15377-1-git-send-email-matt@console-pimps.org>
 <20140609125427.GA16256@redhat.com>
 <CADknwL7Jeh82W3=rEqGqh=37zpqhmMuP1jy+DDq9vb2gQ+9hzg@mail.gmail.com>
 <20140609141512.GA22049@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140609141512.GA22049-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 09 Jun, at 10:15:12AM, Vivek Goyal wrote:
> 
> Ok, thanks. Or I can check whether EFI run time map is there or not. I am
> assuming that efi runtime services are not enabled, then run time map
> will not be there either.

Yes, if runtime services are unavailable then the runtime map will not
be exported.

Now, you can check for the presence of the runtime map from userland but
please don't use that as your check inside the kernel - this is exactly
what efi_enabled() is for.

-- 
Matt Fleming, Intel Open Source Technology Center

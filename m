From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Thu, 6 Dec 2012 06:19:03 +0000
Message-ID: <20121206061903.GA3068@srcf.ucam.org>
References: <20121203200241.GG5906@thinkpad-t410>
 <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
 <20121206001819.GA30527@srcf.ucam.org>
 <50BFE50C.8030008@zytor.com>
 <CAE9FiQX+M+VynyERC0W3y8rvr1tBxWnuBqJ6E-ywC_=HvJE66g@mail.gmail.com>
 <50BFE890.5070109@zytor.com>
 <d8d553fb-1571-4fdc-833c-92b80e15bc25@email.android.com>
 <50BFEF09.9000408@zytor.com>
 <cd3b2e67-92af-494d-ba2d-4179ead6e06b@email.android.com>
 <50BFF328.5030406@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50BFF328.5030406-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mfleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 05, 2012 at 05:21:44PM -0800, H. Peter Anvin wrote:
> On 12/05/2012 05:13 PM, Matthew Garrett wrote:
> >Yeah, it needs to be hidden from root - but ideally we'd be passing it to the second kernel if we kexec. Alternative would be for it to be capability bounded to a trusted signed kexec binary if we implement Vivek's IMA-based approach.
> >
> 
> Either way a security flag in the type field makes sense.

I've no objection to that, although I'm not sure there's any real reason 
to expose an incomplete setup_data to userspace. Any scenario in which 
kexec can't read the full data is one where kexec won't be able to 
call sys_kexec() anyway.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org

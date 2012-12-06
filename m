From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Wed, 05 Dec 2012 19:57:55 -0500
Message-ID: <d8d553fb-1571-4fdc-833c-92b80e15bc25@email.android.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com> <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com> <20121203200241.GG5906@thinkpad-t410> <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com> <20121206001819.GA30527@srcf.ucam.org> <50BFE50C.8030008@zytor.com> <CAE9FiQX+M+VynyERC0W3y8rvr1tBxWnuBqJ6E-ywC_=HvJE66g@mail.gmail.com> <50BFE890.5070109@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50BFE890.5070109-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mfleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:

>I don't think there is anything security-sensitive about that
>information, at least not to root.  I could be wrong, of course; I
>wouldn't mind security people telling me about that.

I don't think there's anything at present, but we'll want to pass the hibernation encryption key from the bootloader to the kernel in the near future. setup_data seems like the easiest way to do that. 

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org

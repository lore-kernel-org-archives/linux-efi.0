From: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Wed, 5 Dec 2012 15:21:35 -0700
Message-ID: <CAErSpo7c5Ph+GufivPt2XFoTbRnAoLnNdZwcc69QMCFdavNJjA@mail.gmail.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
 <20121203200241.GG5906@thinkpad-t410> <CAErSpo7S2+Vt+9bkGLx_=AY9aSGCvAnkHfqu01gTj=eKs7btNw@mail.gmail.com>
 <20121205202254.GA25398@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121205202254.GA25398-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 5, 2012 at 1:22 PM, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:
> On Wed, Dec 05, 2012 at 01:09:25PM -0700, Bjorn Helgaas wrote:
>
>> That's right; nobody stepped up to fix the section mismatch.  I'm
>> happy to fold in your fix, especially if Matthew acks it.
>
> Yes, sorry, I've been way behind on pretty much everything for the past
> few months. Please do add my Ack.
>
>> David, Eric, what about the kexec question?  It looks to me like this
>> wouldn't make things worse than they are today.  If I understand
>> correctly, today we don't use ROM data from EFI on either an initial
>> boot or a kexec.  After this patch, we could use EFI ROM data on the
>> initial boot, but not after a kexec.  So it's worse in the sense that
>> the kexec case doesn't match the initial boot, but at least it's not
>> something that used to work and is now broken.
>
> I think I'd agree here - it's not ideal, but it's no more broken than
> the current situation.

OK, I applied Seth's fix, added his Tested-by, and put this series in
my -next branch.  I plan to merge it during the v3.8 merge window next
week.

Thanks!

Bjorn

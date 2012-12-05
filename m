From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: Use PCI ROMs from EFI boot services
Date: Wed, 5 Dec 2012 20:22:54 +0000
Message-ID: <20121205202254.GA25398@srcf.ucam.org>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
 <20121203200241.GG5906@thinkpad-t410>
 <CAErSpo7S2+Vt+9bkGLx_=AY9aSGCvAnkHfqu01gTj=eKs7btNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAErSpo7S2+Vt+9bkGLx_=AY9aSGCvAnkHfqu01gTj=eKs7btNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mfleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 05, 2012 at 01:09:25PM -0700, Bjorn Helgaas wrote:

> That's right; nobody stepped up to fix the section mismatch.  I'm
> happy to fold in your fix, especially if Matthew acks it.

Yes, sorry, I've been way behind on pretty much everything for the past 
few months. Please do add my Ack.

> David, Eric, what about the kexec question?  It looks to me like this
> wouldn't make things worse than they are today.  If I understand
> correctly, today we don't use ROM data from EFI on either an initial
> boot or a kexec.  After this patch, we could use EFI ROM data on the
> initial boot, but not after a kexec.  So it's worse in the sense that
> the kexec case doesn't match the initial boot, but at least it's not
> something that used to work and is now broken.

I think I'd agree here - it's not ideal, but it's no more broken than 
the current situation.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org

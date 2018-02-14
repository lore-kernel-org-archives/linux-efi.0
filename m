From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: Read-protected UEFI variables
Date: Wed, 14 Feb 2018 14:21:26 +0100
Message-ID: <1518614486.4749.33.camel@profitbricks.com>
References: <1518612748.4749.29.camel@profitbricks.com>
         <CAKv+Gu_V7BCihPhZf=pKrkBZwFWeEoupamXvYSqdS+k93Gme=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_V7BCihPhZf=pKrkBZwFWeEoupamXvYSqdS+k93Gme=g@mail.gmail.com>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Am Mittwoch, den 14.02.2018, 13:09 +0000 schrieb Ard Biesheuvel:
> On 14 February 2018 at 12:52, Benjamin Drung
> <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> > Hi,
> > 
> > I am exploring the possibility to store SSH and other keys in UEFI
> > variables for systems that do not have persistent storage. These
> > systems boot via network and need individual SSH keys which ideally
> > should not be distributed via network.
> > 
> > The plan is to write a small daemon that starts at boot and gets
> > the
> > SSH keys from EFI variables to individualize the system with SSH
> > keys.
> > I plan to release the code as free software. Simple proof-of-
> > concept
> > code:
> > 
> > mount -t efivarfs none /sys/firmware/efi/efivars
> > for key in ssh_host_dsa_key ssh_host_ecdsa_key ssh_host_rsa_key; do
> >   dd ibs=1 skip=4 if=/sys/firmware/efi/efivars/${key}-89df11f4-
> > 38e6-473e-ab43-b4406b76fba9 of=/etc/ssh/$key
> > done
> > 
> > I am not the first person having the idea to use UEFI variables to
> > store keys:
> > https://www.usenix.org/conference/srecon17asia/program/presentation
> > /korgachin
> > 
> > There is one problem: The keys should be readable only by root.
> > When
> > mounting efivarfs, all variables have the permission 644 which
> > makes
> > them readable by all users. I have different ideas how to solve it:
> > 
> > 1) Hard-code a list of GUIDs that should be only readable by root
> > in
> > the kernel module. These modules would also be not set to
> > immutable.
> > 
> > 2) Instead of hard-coding GUIDs, add a kernel module parameter to
> > specify the GUIDs. Maybe have a default list in the kernel module.
> > 
> > 3) Add a mount option to specify the protected GUIDs.
> > 
> > Feedback is welcome.
> > 
> 
> I'd consider a patch that makes the permissions a mount option for
> efivarfs, applying to all variables. The reason is that these
> variables shouldn't have been world readable in the first place, and
> I
> am reluctant to make this overly complex.

Having some variables (like the BootXXXX and BootOrder variables) world
readable is useful. This allows normal users to run 'efibootmgr' to
display the boot options.

> On the other hand, you should realize that UEFI was never designed to
> keep secrets, and so whether it is a good idea to put secrets in UEFI
> variables to begin with is dubious IMHO.

If the UEFI is as secure as storing an unencrypted file on a hard
drive, I am satisfied. Or do you have a better idea where to store the
SSH keys for a diskless system that boots via network?

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Read-protected UEFI variables
Date: Thu, 15 Feb 2018 19:04:22 +0000
Message-ID: <CAKv+Gu8x40ACoKNoUJ9SQ9PJmDoomNhjO937sjhkqmrL+ErovQ@mail.gmail.com>
References: <1518612748.4749.29.camel@profitbricks.com> <CAKv+Gu_V7BCihPhZf=pKrkBZwFWeEoupamXvYSqdS+k93Gme=g@mail.gmail.com>
 <1518614486.4749.33.camel@profitbricks.com> <b189516a-61b9-bf81-3d28-9873f5530997@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b189516a-61b9-bf81-3d28-9873f5530997@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Benjamin Drung <benjamin.drung@profitbricks.com>, Matthew Garrett <matthew.garrett@nebula.com>, Jeremy Kerr <jk@ozlabs.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

FYI https://marc.info/?l=linux-efi&m=151871896117989&w=2


On 14 February 2018 at 20:33, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> On 2018-02-14 08:21, Benjamin Drung wrote:
>>
>> Am Mittwoch, den 14.02.2018, 13:09 +0000 schrieb Ard Biesheuvel:
>>>
>>> On 14 February 2018 at 12:52, Benjamin Drung
>>> <benjamin.drung@profitbricks.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> I am exploring the possibility to store SSH and other keys in UEFI
>>>> variables for systems that do not have persistent storage. These
>>>> systems boot via network and need individual SSH keys which ideally
>>>> should not be distributed via network.
>>>>
>>>> The plan is to write a small daemon that starts at boot and gets
>>>> the
>>>> SSH keys from EFI variables to individualize the system with SSH
>>>> keys.
>>>> I plan to release the code as free software. Simple proof-of-
>>>> concept
>>>> code:
>>>>
>>>> mount -t efivarfs none /sys/firmware/efi/efivars
>>>> for key in ssh_host_dsa_key ssh_host_ecdsa_key ssh_host_rsa_key; do
>>>>    dd ibs=1 skip=4 if=/sys/firmware/efi/efivars/${key}-89df11f4-
>>>> 38e6-473e-ab43-b4406b76fba9 of=/etc/ssh/$key
>>>> done
>>>>
>>>> I am not the first person having the idea to use UEFI variables to
>>>> store keys:
>>>> https://www.usenix.org/conference/srecon17asia/program/presentation
>>>> /korgachin
>>>>
>>>> There is one problem: The keys should be readable only by root.
>>>> When
>>>> mounting efivarfs, all variables have the permission 644 which
>>>> makes
>>>> them readable by all users. I have different ideas how to solve it:
>>>>
>>>> 1) Hard-code a list of GUIDs that should be only readable by root
>>>> in
>>>> the kernel module. These modules would also be not set to
>>>> immutable.
>>>>
>>>> 2) Instead of hard-coding GUIDs, add a kernel module parameter to
>>>> specify the GUIDs. Maybe have a default list in the kernel module.
>>>>
>>>> 3) Add a mount option to specify the protected GUIDs.
>>>>
>>>> Feedback is welcome.
>>>>
>>>
>>> I'd consider a patch that makes the permissions a mount option for
>>> efivarfs, applying to all variables. The reason is that these
>>> variables shouldn't have been world readable in the first place, and
>>> I
>>> am reluctant to make this overly complex.
>>
>>
>> Having some variables (like the BootXXXX and BootOrder variables) world
>> readable is useful. This allows normal users to run 'efibootmgr' to
>> display the boot options.
>
> Some variables maybe (ISTR variables for things like the system time-zone or
> the firmware locale settings, which _might_ be useful), but I would say the
> boot variables are not on that list.  The only practical application for a
> regular (non-root) user to read those variables is to gather info for an
> attack on the system.  Anybody who legitimately needs to access them (either
> for debugging the boot process, or changing the boot options) should have
> administrative access to the system anyway, and even then they will usually
> not need to read them.
>
> In fact, most of the UEFI variables fall into the same category, but even
> more so, userspace has no legitimate reason to need to read them. You can
> get an absolutely insane amount of info out of them on some systems, most of
> which is a gold-mine for potential attackers.  For the handful that may
> actually be useful to userspace, most would be needed only during system
> startup, and thus could safely be made readable by root only.
>>
>>
>>> On the other hand, you should realize that UEFI was never designed to
>>> keep secrets, and so whether it is a good idea to put secrets in UEFI
>>> variables to begin with is dubious IMHO.
>>
>>
>> If the UEFI is as secure as storing an unencrypted file on a hard
>> drive, I am satisfied. Or do you have a better idea where to store the
>> SSH keys for a diskless system that boots via network?
>>
> There really isn't any other option unless you're willing to put a small
> amount of flash storage in the system somehow (maybe a small USB flash drive
> connected directly to a USB header inside the system?).  As far as the
> security of UEFI variables, the same limitations as storing the data on an
> unencrypted hard drive apply, with the addition that it's much easier to get
> at them through stuff like Intel's AMT or IPMI than it is to read data off
> of the hard drive.

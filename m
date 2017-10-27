From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: Multiple Acer laptops hang on ACPI poweroff
Date: Fri, 27 Oct 2017 09:57:38 +0200
Message-ID: <CAJZ5v0hXDHU4f5dXD3DrUszgiJWr0tzjM04bC66-qsEdRf6gUg@mail.gmail.com>
References: <20170303201524.8150-1-drake@endlessm.com> <CAD8Lp44G_1R4gP9AFpEm34Y+DBmnWGgpBZbuTjimhi9uCQEKdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <CAD8Lp44G_1R4gP9AFpEm34Y+DBmnWGgpBZbuTjimhi9uCQEKdg@mail.gmail.com>
Sender: linux-pm-owner@vger.kernel.org
To: Daniel Drake <drake@endlessm.com>
Cc: linux-efi@vger.kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Linux PM <linux-pm@vger.kernel.org>, Linux Upstreaming Team <linux@endlessm.com>, Chris Chiu <chiu@endlessm.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 27, 2017 at 8:35 AM, Daniel Drake <drake@endlessm.com> wrote:
> On Sat, Mar 4, 2017 at 4:15 AM, Daniel Drake <drake@endlessm.com> wrote:
>> Some particular Acer/Packard Bell machines hang during shutdown.
>> The system completely hangs while doing bit operations for turning on SLP_EN
>> bit in ACPI PM1A control address and Sleep Control Register. Thus the
>> normal acpi_power_off path can never complete the shutdown process.
>>
>> We have found a workaround to force these systems to use EFI for poweroff,
>> included below, but I wonder if anything better can be done.

Maybe it can, but I need to investigate.

>> It is especially not ideal because the system hangs the same way when going
>> into suspend and we don't have a workaround for that.

It may just not do S3 at all if it shipped with Windows 10.
Suspend-to-idle is the only way to suspend such platforms.

> Testing shutdown on Acer Aspire ES1-732 (Intel Apollo Lake N4200) on
> Linux 4.14-rc6, this issue is still present.
>
> The FADT has:
>
> [0ACh 0172  12]           PM1A Control Block : [Generic Address Structure]
> [0ACh 0172   1]                     Space ID : 01 [SystemIO]
> [0ADh 0173   1]                    Bit Width : 10
> [0AEh 0174   1]                   Bit Offset : 00
> [0AFh 0175   1]         Encoded Access Width : 02 [Word Access:16]
> [0B0h 0176   8]                      Address : 0000000000000404
>
> Full ACPI tables dump:
> https://gist.github.com/dsd/ed80d9fdd32f99e310002b2492cd6e1b
>
> We have tested that writing bit 13 of port 0404 under Windows 10
> (using an app called RW everything) results in an immediate and
> successful power down. However, writing the same bit under Linux just
> makes the system hang.
>
> I am not really familiar with the guts of x86 systems. When the OS
> writes to this port, which component of the system receives that
> request and acts accordingly? Is it handled by the BIOS? Or an EC, or
> ...? With more background here we may be able to approach the relevant
> component vendor and ask for help.

Writes to the PM1A register may go straight to the PMC or trigger an
SMM trap.  In both cases the platform takes over.

Is Apollo Lake the only platform affected or are there any other?

Thanks,
Rafael

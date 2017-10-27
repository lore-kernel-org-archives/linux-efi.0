From: Daniel Drake <drake@endlessm.com>
Subject: Re: Multiple Acer laptops hang on ACPI poweroff
Date: Fri, 27 Oct 2017 16:40:30 +0800
Message-ID: <CAD8Lp47xEBPQVVDf0SQyAQHb1kXO4YpBq8DUz2u3Qnqj7RDDuQ@mail.gmail.com>
References: <20170303201524.8150-1-drake@endlessm.com> <CAD8Lp44G_1R4gP9AFpEm34Y+DBmnWGgpBZbuTjimhi9uCQEKdg@mail.gmail.com>
 <CAJZ5v0hXDHU4f5dXD3DrUszgiJWr0tzjM04bC66-qsEdRf6gUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <CAJZ5v0hXDHU4f5dXD3DrUszgiJWr0tzjM04bC66-qsEdRf6gUg@mail.gmail.com>
Sender: linux-pm-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-efi@vger.kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Linux PM <linux-pm@vger.kernel.org>, Linux Upstreaming Team <linux@endlessm.com>, Chris Chiu <chiu@endlessm.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 27, 2017 at 3:57 PM, Rafael J. Wysocki <rafael@kernel.org> wrote:
>> Testing shutdown on Acer Aspire ES1-732 (Intel Apollo Lake N4200) on
>> Linux 4.14-rc6, this issue is still present.
>>
>> The FADT has:
>>
>> [0ACh 0172  12]           PM1A Control Block : [Generic Address Structure]
>> [0ACh 0172   1]                     Space ID : 01 [SystemIO]
>> [0ADh 0173   1]                    Bit Width : 10
>> [0AEh 0174   1]                   Bit Offset : 00
>> [0AFh 0175   1]         Encoded Access Width : 02 [Word Access:16]
>> [0B0h 0176   8]                      Address : 0000000000000404
>>
>> Full ACPI tables dump:
>> https://gist.github.com/dsd/ed80d9fdd32f99e310002b2492cd6e1b
>>
>> We have tested that writing bit 13 of port 0404 under Windows 10
>> (using an app called RW everything) results in an immediate and
>> successful power down. However, writing the same bit under Linux just
>> makes the system hang.
>>
>> I am not really familiar with the guts of x86 systems. When the OS
>> writes to this port, which component of the system receives that
>> request and acts accordingly? Is it handled by the BIOS? Or an EC, or
>> ...? With more background here we may be able to approach the relevant
>> component vendor and ask for help.
>
> Writes to the PM1A register may go straight to the PMC or trigger an
> SMM trap.  In both cases the platform takes over.

Platform means BIOS/firmware? (i.e. Insyde in this case)
Or you are referring to the Intel SoC?

> Is Apollo Lake the only platform affected or are there any other?

All 3 affected product families are Apollo Lake

Thanks
Daniel

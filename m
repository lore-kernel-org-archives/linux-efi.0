From: Naresh Bhat <naresh.bhat@linaro.org>
Subject: Re: [PATCH V5 0/3] Use efi_rts_wq to invoke EFI Runtime Services
Date: Wed, 6 Jun 2018 14:12:43 +0530
Message-ID: <CAFoFrHbOkKpfrt-NVX9wm49aR1Mv7dXLVrDuXGQPiD0ZNbvyrw@mail.gmail.com>
References: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAFoFrHYcD7fGYaJzKwcPCtu+XyR+mh5ORDqmCpiBjLmEkDfwOQ@mail.gmail.com> <FFF73D592F13FD46B8700F0A279B802F3B6EABDF@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F3B6EABDF@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Nair, Jayachandran" <Jayachandran.Nair@cavium.com>
List-Id: linux-efi@vger.kernel.org

On 4 June 2018 at 09:57, Prakhya, Sai Praneeth
<sai.praneeth.prakhya@intel.com> wrote:
>> > Testing:
>> > --------
>> > Tested using LUV (Linux UEFI Validation) for x86_64, x86_32 and arm64
>> > (qemu only). Will appreciate the effort if someone could test the
>> > patches on real ARM/ARM64 machines.
>> > LUV: https://01.org/linux-uefi-validation
>>
>> I have tested V4 series on ThunderX2 Val1 and Saber platform by integrating the
>> patches with LUV project.
>> I will test V5 version soon and let you know the outcome.
>
> Thanks a lot! for taking time to test the patch set, Naresh. Will be waiting to see the result.

Sai, I did upgrade LUV kernel to v4.17, apply and test your patches by
running LUV on QEMU and ThunderX2 hardware.  All efi test results
looks ok. But as Ard pointed, I also noticed hang issue after
executing reboot command on console on real hardware.


>
> Regards,
> Sai

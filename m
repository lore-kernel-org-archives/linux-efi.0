From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 1/2] ia64: split off early_ioremap() declarations into asm/early_ioremap.h
Date: Thu, 14 Jan 2016 08:19:36 +0100
Message-ID: <CAKv+Gu9j=mHsPw23fuUi2z0qMpQxVevHU6F8nCYCqDnt_h-MzQ@mail.gmail.com>
References: <1452604966-9905-1-git-send-email-ard.biesheuvel@linaro.org>
	<3908561D78D1C84285E8C5FCA982C28F39FAC179@ORSMSX114.amr.corp.intel.com>
	<20160113103454.GD25458@arm.com>
	<3908561D78D1C84285E8C5FCA982C28F39FAD443@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F39FAD443@ORSMSX114.amr.corp.intel.com>
Sender: linux-ia64-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux@roeck-us.net" <linux@roeck-us.net>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "Yu, Fenghua" <fenghua.yu@intel.com>
List-Id: linux-efi@vger.kernel.org

On 13 January 2016 at 22:36, Luck, Tony <tony.luck@intel.com> wrote:
>> The arm trees have already been pulled, so the breakage is in mainline.
>>
>> I think it makes the most sense to fix this either via the ia64 or the
>> efi tree, but I'll queue something at -rc1 if it's still not resolved by
>> then.
>
> I put the two patches in the ia64 tree and sent a pull request to Linus.
>

Thanks Tony

From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Date: Thu, 04 Sep 2014 13:59:05 -0700
Message-ID: <5408D299.5000300@zytor.com>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org> <20140904100137.GK3001@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140904100137.GK3001@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>, =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>, Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 09/04/2014 03:01 AM, Matt Fleming wrote:
> On Wed, 03 Sep, at 09:50:07PM, Yinghai Lu wrote:
>> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initr=
d
>> loaded above 4G"), the kernel freezes at the earliest possible momen=
t
>> when trying to boot via UEFI on Asus laptop.
>>
>> Revert to old way to load initrd under 4G on first try,
>> second try will use above 4G buffer when initrd is too big
>> and does not fit under 4G.
>>
>> -v2: add print out for second try, and print out files buf address.
>> -v3: can not snprintf
>> -v4: drop address print out for files buf
>>
>> Reported-by: Mantas Mikul=C4=97nas <grawity@gmail.com>
>> Tested-by: Anders Darander <anders@chargestorm.se>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/boot/compressed/eboot.c |   18 +++++++++++-------
>>  1 file changed, 11 insertions(+), 7 deletions(-)
>=20
> Thanks, I've picked this up and expanded on the commit message becaus=
e a
> lot of useful information was discussed on the mailing list that we
> should definitely include.
>=20
>   http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit=
/?h=3Durgent&id=3Db524e05df6d466af2f7eea1f044369109e48e641
>=20

I am fine with this patch, but at the same time I do want to note that
there is an alternative to double-buffer the patch and/or (if that
applies to the buggy BIOS) round up the size of the target buffer.

	-hpa

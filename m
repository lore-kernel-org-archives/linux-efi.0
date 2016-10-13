From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH V3 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Thu, 13 Oct 2016 09:50:15 +0100
Message-ID: <064dca7d-0625-c0d0-09ae-72ef7abdc63f@arm.com>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
 <1475875882-2604-3-git-send-email-tbaicar@codeaurora.org>
 <3f17d0a8-6b63-5792-903a-341effaae432@arm.com>
 <c17a0c03-5037-d88d-f096-4cc72dbfcb99@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <c17a0c03-5037-d88d-f096-4cc72dbfcb99@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Baicar, Tyler" <tbaicar@codeaurora.org>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Dkvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org
Cc: Naveen Kaje <nkaje@codeaurora.org>, Richard Ruigrok <rruigrok@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

On 12/10/16 23:10, Baicar, Tyler wrote:
> Hello Suzuki,
>
> Thank you for the feedback! Responses below.
>
>
> On 10/11/2016 11:28 AM, Suzuki K Poulose wrote:
>> On 07/10/16 22:31, Tyler Baicar wrote:
>>> Currently when a RAS error is reported it is not timestamped.
>>> The ACPI 6.1 spec adds the timestamp field to the generic error
>>> data entry v3 structure. The timestamp of when the firmware
>>> generated the error is now being reported.
>>>
>>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
>>> Signed-off-by: Richard Ruigrok <rruigrok@codeaurora.org>
>>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>>> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
>>
>> Please could you keep the people who reviewed/commented on your series i=
n the past,
>> whenever you post a new version ?
> Do you mean to just send the new version to their e-mail directly in addi=
tion to the lists? If so, I will do that next time.

If you send a new version of a series to the list, it is a good idea to keep
the people who commented (significantly) on your previous version in Cc, es=
pecially
when you have addressed their feedback. That will help them to keep track o=
f the
series. People can always see the new version in the list, but then it is s=
o easy
to miss something in the 100s of emails you get each day. I am sure people =
have
special filters for the emails based on if they are in Cc/To etc.

>
> I know you provided good feedback on the previous patchset, but I did not=
 have anyone specifically respond to add "reviewed-by:...". I don't think I=
 should add reviewed-by for someone unless they specifically add it in a re=
sponse :)

No, I haven't yet "Reviewed-by" your patches. I had some comments on it, wh=
ich means
I expected it to be addressed as you committed in your response.

>>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>>> index 3021f0e..c8488f1 100644
>>> --- a/drivers/acpi/apei/ghes.c
>>> +++ b/drivers/acpi/apei/ghes.c
>>> @@ -80,6 +80,10 @@

> I think that should work to avoid duplication. I will move them to a head=
er file in the next patchset.
>>> +
>>> +static void cper_estatus_print_section_v300(const char *pfx,
>>> +    const struct acpi_hest_generic_data_v300 *gdata)
>>> +{
>>> +    __u8 hour, min, sec, day, mon, year, century, *timestamp;
>>> +
>>> +    if (gdata->validation_bits & ACPI_HEST_GEN_VALID_TIMESTAMP) {
>>> +        timestamp =3D (__u8 *)&(gdata->time_stamp);
>>> +        memcpy(&sec, timestamp, 1);
>>> +        memcpy(&min, timestamp + 1, 1);
>>> +        memcpy(&hour, timestamp + 2, 1);
>>> +        memcpy(&day, timestamp + 4, 1);
>>> +        memcpy(&mon, timestamp + 5, 1);
>>> +        memcpy(&year, timestamp + 6, 1);
>>> +        memcpy(&century, timestamp + 7, 1);
>>> +        printk("%stime: ", pfx);
>>> +        printk("%7s", 0x01 & *(timestamp + 3) ? "precise" : "");
>>
>> What format is the (timestamp + 3) stored in ? Does it need conversion ?
> The third byte of the timestamp is currently only used to determine if th=
e time is precise or not. Bit 0 is used to specify that and the other bits =
in this byte are marked as reserved. This is shown in table 247 of the UEFI=
 spec 2.6:
>
> Byte 3:
>   Bit 0 =96 Timestamp is precise if this bit is set and correlates to the=
 time of the error event.
>   Bit 7:1 =96 Reserved

Is it always the same endianness as that of the CPU ?

Cheers
Suzuki

From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V3 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Wed, 12 Oct 2016 16:10:52 -0600
Message-ID: <c17a0c03-5037-d88d-f096-4cc72dbfcb99@codeaurora.org>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
 <1475875882-2604-3-git-send-email-tbaicar@codeaurora.org>
 <3f17d0a8-6b63-5792-903a-341effaae432@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <3f17d0a8-6b63-5792-903a-341effaae432@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, sandeepa.s.prabhu@gmail.com, shijie.huang@arm.com, paul.gortmaker@windriver.com, tomasz.nowicki@linaro.org, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Dkvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org
Cc: Naveen Kaje <nkaje@codeaurora.org>, Richard Ruigrok <rruigrok@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

Hello Suzuki,

Thank you for the feedback! Responses below.


On 10/11/2016 11:28 AM, Suzuki K Poulose wrote:
> On 07/10/16 22:31, Tyler Baicar wrote:
>> Currently when a RAS error is reported it is not timestamped.
>> The ACPI 6.1 spec adds the timestamp field to the generic error
>> data entry v3 structure. The timestamp of when the firmware
>> generated the error is now being reported.
>>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
>> Signed-off-by: Richard Ruigrok <rruigrok@codeaurora.org>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
>
> Please could you keep the people who reviewed/commented on your series =

> in the past,
> whenever you post a new version ?
Do you mean to just send the new version to their e-mail directly in =

addition to the lists? If so, I will do that next time.

I know you provided good feedback on the previous patchset, but I did =

not have anyone specifically respond to add "reviewed-by:...". I don't =

think I should add reviewed-by for someone unless they specifically add =

it in a response :)
>
>> ---
>>  drivers/acpi/apei/ghes.c    | 25 ++++++++++--
>>  drivers/firmware/efi/cper.c | 97 =

>> +++++++++++++++++++++++++++++++++++++++------
>>  2 files changed, 105 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index 3021f0e..c8488f1 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -80,6 +80,10 @@
>>      ((struct acpi_hest_generic_status *)                \
>>       ((struct ghes_estatus_node *)(estatus_node) + 1))
>>
>> +#define acpi_hest_generic_data_version(gdata)            \
>> +    (gdata->revision >> 8)
>
> ...
>
>> +inline void *acpi_hest_generic_data_payload(struct =

>> acpi_hest_generic_data *gdata)
>> +{
>> +    return acpi_hest_generic_data_version(gdata) >=3D 3 ?
>> +        (void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1) :
>> +        gdata + 1;
>> +}
>> +
>
>
>
>> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
>> index d425374..9fa1317 100644
>> --- a/drivers/firmware/efi/cper.c
>> +++ b/drivers/firmware/efi/cper.c
>
>> +#define acpi_hest_generic_data_version(gdata)        \
>> +    (gdata->revision >> 8)
>> +
>
> ...
>
>> +static inline void *acpi_hest_generic_data_payload(struct =

>> acpi_hest_generic_data *gdata)
>> +{
>> +    return acpi_hest_generic_data_version(gdata) >=3D 3 ?
>> +        (void *)(((struct acpi_hest_generic_data_v300 *)(gdata)) + 1) :
>> +        gdata + 1;
>> +}
>
> Could these go to a header file, so that we don't need duplicate =

> definitions of these helpers in
> different files ?
>
I think that should work to avoid duplication. I will move them to a =

header file in the next patchset.
>> +
>> +static void cper_estatus_print_section_v300(const char *pfx,
>> +    const struct acpi_hest_generic_data_v300 *gdata)
>> +{
>> +    __u8 hour, min, sec, day, mon, year, century, *timestamp;
>> +
>> +    if (gdata->validation_bits & ACPI_HEST_GEN_VALID_TIMESTAMP) {
>> +        timestamp =3D (__u8 *)&(gdata->time_stamp);
>> +        memcpy(&sec, timestamp, 1);
>> +        memcpy(&min, timestamp + 1, 1);
>> +        memcpy(&hour, timestamp + 2, 1);
>> +        memcpy(&day, timestamp + 4, 1);
>> +        memcpy(&mon, timestamp + 5, 1);
>> +        memcpy(&year, timestamp + 6, 1);
>> +        memcpy(&century, timestamp + 7, 1);
>> +        printk("%stime: ", pfx);
>> +        printk("%7s", 0x01 & *(timestamp + 3) ? "precise" : "");
>
> What format is the (timestamp + 3) stored in ? Does it need conversion ?
The third byte of the timestamp is currently only used to determine if =

the time is precise or not. Bit 0 is used to specify that and the other =

bits in this byte are marked as reserved. This is shown in table 247 of =

the UEFI spec 2.6:

Byte 3:
   Bit 0 =96 Timestamp is precise if this bit is set and correlates to the =

time of the error event.
   Bit 7:1 =96 Reserved
>
>> +        printk(" %02d:%02d:%02d %02d%02d-%02d-%02d\n",
>> +            bcd2bin(hour), bcd2bin(min), bcd2bin(sec),
>> +            bcd2bin(century), bcd2bin(year), bcd2bin(mon),
>> +            bcd2bin(day));
>> +    }
>
> minor nit: Would it be easier to order/parse the error messages if the =

> date
> is printed first followed by time ?
>
> i.e,
>     17:20:14 2016-09-15 Mon
>         vs
>     2016-09-15 Mon 17:20:14
>
> e.g, people looking at a huge log, looking for logs from a specific =

> date might
> find the latter more useful to skip the messages.
>
The latter does seem like it would be better for parsing large logs. I =

can rearrange the order in the next patchset.
>> +}
>> +
>>  static void cper_estatus_print_section(
>> -    const char *pfx, const struct acpi_hest_generic_data *gdata, int =

>> sec_no)
>> +    const char *pfx, struct acpi_hest_generic_data *gdata, int sec_no)
>>  {
>>      uuid_le *sec_type =3D (uuid_le *)gdata->section_type;
>>      __u16 severity;
>>      char newpfx[64];
>>
>> +    if ((gdata->revision >> 8) >=3D 0x03)
>
> Could we use the helper defined above ?
Yes, I'll change this to use acpi_hest_generic_data_version(gdata) instead.
>
>> @@ -451,12 +497,22 @@ void cper_estatus_print(const char *pfx,
>>      printk("%s""event severity: %s\n", pfx, =

>> cper_severity_str(severity));
>>      data_len =3D estatus->data_length;
>>      gdata =3D (struct acpi_hest_generic_data *)(estatus + 1);
>> +    if ((gdata->revision >> 8) >=3D 0x03)
>
> Same as above, use the macro ?
Yes, I'll change this to use acpi_hest_generic_data_version(gdata) instead.
>
>> +        gdata_v3 =3D (struct acpi_hest_generic_data_v300 *)gdata;
>> +
>>      snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
>> +
>>      while (data_len >=3D sizeof(*gdata)) {
>>          gedata_len =3D gdata->error_data_length;
>>          cper_estatus_print_section(newpfx, gdata, sec_no);
>> -        data_len -=3D gedata_len + sizeof(*gdata);
>> -        gdata =3D (void *)(gdata + 1) + gedata_len;
>> +        if(gdata_v3) {
>> +            data_len -=3D gedata_len + sizeof(*gdata_v3);
>> +            gdata_v3 =3D (void *)(gdata_v3 + 1) + gedata_len;
>> +            gdata =3D (struct acpi_hest_generic_data *)gdata_v3;
>> +        } else {
>> +            data_len -=3D gedata_len + sizeof(*gdata);
>> +            gdata =3D (void *)(gdata + 1) + gedata_len;
>> +        }
>>          sec_no++;
>>      }
>
> ...
>
>>
>> @@ -486,15 +543,29 @@ int cper_estatus_check(const struct =

>> acpi_hest_generic_status *estatus)
>>          return rc;
>>      data_len =3D estatus->data_length;
>>      gdata =3D (struct acpi_hest_generic_data *)(estatus + 1);
>> -    while (data_len >=3D sizeof(*gdata)) {
>> -        gedata_len =3D gdata->error_data_length;
>> -        if (gedata_len > data_len - sizeof(*gdata))
>> +
>> +    if ((gdata->revision >> 8) >=3D 0x03) {
>> +        gdata_v3 =3D (struct acpi_hest_generic_data_v300 *)gdata;
>> +        while (data_len >=3D sizeof(*gdata_v3)) {
>> +            gedata_len =3D gdata_v3->error_data_length;
>> +            if (gedata_len > data_len - sizeof(*gdata_v3))
>> +                return -EINVAL;
>> +            data_len -=3D gedata_len + sizeof(*gdata_v3);
>> +            gdata_v3 =3D (void *)(gdata_v3 + 1) + gedata_len;
>> +        }
>> +        if (data_len)
>> +            return -EINVAL;
>> +    } else {
>> +        while (data_len >=3D sizeof(*gdata)) {
>> +            gedata_len =3D gdata->error_data_length;
>> +            if (gedata_len > data_len - sizeof(*gdata))
>> +                return -EINVAL;
>> +            data_len -=3D gedata_len + sizeof(*gdata);
>> +            gdata =3D (void *)(gdata + 1) + gedata_len;
>> +        }
>> +        if (data_len)
>
> As mentioned in the previous version, would it make sense to add some =

> more
> helpers to deal with record versions ? We seem to be doing the version =

> switch and
> code duplication at different places.
>
> Does the following help ? Thoughts ?
>
> #define acpi_hest_generic_data_error_length(gdata) (((struct =

> acpi_hest_generic_data *)(gdata))->error_data_length)
> #define acpi_hest_generic_data_size(gdata) \
>     ((acpi_hest_generic_data_version(gdata) >=3D 3) ? \
>      sizeof(struct acpi_hest_generic_data_v300) :    \
>      sizeof(struct acpi_hest_generic_data))
> #define acpi_hest_generic_data_record_size(gdata)
>     (acpi_hest_generic_data_size(gdata) + \
>      acpi_hest_generic_data_error_length(gdata))
> #define acpi_hest_generic_data_next(gdata) \
>     ((void *)(gdata) + acpi_hest_generic_data_record_size(gdata))
>
>
> Suzuki
These helpers will definitely help consolidate this code. I will use =

these in the next version to remove the code duplication here.

Thanks,
Tyler

-- =

Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technolo=
gies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

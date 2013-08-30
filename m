From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 12/16] Fix types in EFI calls to match EFI function definitions.
Date: Fri, 30 Aug 2013 16:12:24 -0700
Message-ID: <CAFECyb-J4gTiAQkKVT8qt94Tk6-_jVdX=sNM7VkXkyvPdEeZFA@mail.gmail.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	<1376090777-20090-13-git-send-email-roy.franz@linaro.org>
	<20130830133902.AEA7A3E102A@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130830133902.AEA7A3E102A@localhost>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 30, 2013 at 6:39 AM, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org> wrote:
> On Fri,  9 Aug 2013 16:26:13 -0700, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> EFI calls can made directly on ARM, so the function pointers
>> are directly invoked.  This allows types to be checked at
>> compile time, so here we ensure that the parameters match
>> the function signature.
>>
>> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/efi-stub-helper.c |   15 +++++++++------
>>  1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
>> index b707a9f..4bb542f 100644
>> --- a/drivers/firmware/efi/efi-stub-helper.c
>> +++ b/drivers/firmware/efi/efi-stub-helper.c
>> @@ -321,7 +321,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>>       status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
>>                               EFI_LOADER_DATA,
>>                               nr_files * sizeof(*files),
>> -                             &files);
>> +                             (void **)&files);
>>       if (status != EFI_SUCCESS) {
>>               efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
>>               goto fail;
>> @@ -372,7 +372,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>>                       boottime = sys_table_arg->boottime;
>>
>>                       status = efi_call_phys3(boottime->handle_protocol,
>> -                                     image->device_handle, &fs_proto, &io);
>> +                                     image->device_handle, &fs_proto,
>> +                                             (void **)&io);
>>                       if (status != EFI_SUCCESS) {
>>                               efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
>>                               goto free_files;
>> @@ -406,7 +407,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>>
>>  grow:
>>               status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
>> -                                     EFI_LOADER_DATA, info_sz, &info);
>> +                                     EFI_LOADER_DATA, info_sz,
>> +                                     (void **)&info);
>>               if (status != EFI_SUCCESS) {
>>                       efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
>>                       goto close_handles;
>> @@ -456,18 +458,19 @@ grow:
>>
>>               addr = file_addr;
>>               for (j = 0; j < nr_files; j++) {
>> -                     u64 size;
>> +                     unsigned long size;
>>
>>                       size = files[j].size;
>>                       while (size) {
>> -                             u64 chunksize;
>> +                             unsigned long chunksize;
>>                               if (size > EFI_READ_CHUNK_SIZE)
>>                                       chunksize = EFI_READ_CHUNK_SIZE;
>>                               else
>>                                       chunksize = size;
>>                               status = efi_call_phys3(fh->read,
>>                                                       files[j].handle,
>> -                                                     &chunksize, addr);
>> +                                                     &chunksize,
>> +                                                     (void *)addr);
>
> I think you need some description in the commit text about why the type
> of chunksize is changing. It's not clear why you're making this change.
> It is a bug fix?

The type was changed to match the EFI_FILE_PROTOCOL specification -
chunk size is
defined as a native width unsigned integer.  So yes, this is a bug in
that this is wrong for
ia32, since that really should be a u32 in that case.
Since the x86 wrappers break type checking by the compiler these types
were never checked at compile time
before.  chunksize is the the only change that isn't a cast to a type
of void pointer.

I can break this change out as a separate patch if desired.

Matt - would you like me to split the chunksize type change into a
separate patch from the arm EFI stub series?

Roy



>
> g.

From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 2/3] efi-pstore: implement efivars_pstore_exit()
Date: Wed, 11 Nov 2015 15:08:34 -0800
Message-ID: <CAGXu5j+DADxC6LrHMSAnw5N2GRFbby6-iPTgkKC=BZotBqt-NQ@mail.gmail.com>
References: <cover.1446869434.git.geliangtang@163.com>
	<337377a3fbcf855d6a5217e06fcd8c8a979f2853.1446869434.git.geliangtang@163.com>
	<c203e0cfee351d6f97c6a1a42c3e25b4be339f93.1446869434.git.geliangtang@163.com>
	<20151111165947.GD4889@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151111165947.GD4889@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Geliang Tang <geliangtang@163.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 11, 2015 at 8:59 AM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Sat, 07 Nov, at 12:43:48PM, Geliang Tang wrote:
>> The original efivars_pstore_exit() is empty. I
>>  1) add a bufsize check statement.
>>  2) call pstore_unregister as it is defined now.
>>  3) free the memory and set bufsize to 0.
>>
>> Signed-off-by: Geliang Tang <geliangtang@163.com>
>> ---
>>  drivers/firmware/efi/efi-pstore.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
>> index eac76a7..62d57d8 100644
>> --- a/drivers/firmware/efi/efi-pstore.c
>> +++ b/drivers/firmware/efi/efi-pstore.c
>> @@ -393,6 +393,13 @@ static __init int efivars_pstore_init(void)
>>
>>  static __exit void efivars_pstore_exit(void)
>>  {
>> +     if (!efi_pstore_info.bufsize)
>> +             return;
>> +
>> +     pstore_unregister(&efi_pstore_info);
>> +     kfree(efi_pstore_info.buf);
>> +     efi_pstore_info.buf = NULL;
>> +     efi_pstore_info.bufsize = 0;
>>  }
>>
>>  module_init(efivars_pstore_init);
>
> Looks OK to me. Kees, are you picking this up?

I can, though usually it goes through Tony.

-Kees

-- 
Kees Cook
Chrome OS Security

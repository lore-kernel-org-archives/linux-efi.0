From: ivanhu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH 1/3] efi/efi_test: use memdup_user() as a cleanup
Date: Wed, 5 Oct 2016 09:31:01 +0800
Message-ID: <fc934b37-d7c2-3ec2-76d0-6c0b4e501765@canonical.com>
References: <1474859691-8574-1-git-send-email-ivan.hu@canonical.com>
 <1474859691-8574-2-git-send-email-ivan.hu@canonical.com>
 <20161003201718.GL16071@codeblueprint.co.uk>
 <3fb6d9fa-b554-509b-fc59-d75340017589@canonical.com>
 <20161004213743.GV16071@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161004213743.GV16071-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 2016年10月05日 05:37, Matt Fleming wrote:
> On Tue, 04 Oct, at 11:04:56AM, ivanhu wrote:
>> Hi Matt,
>>
>> The warning message is from Kbuild test robot,
>>
>> https://chromium.googlesource.com/linux-fpga-chameleon/+/fpga-chameleon-4.2/scripts/coccinelle/api/memdup_user.cocci,
>>
>>
>> and  I believe it tries to persuade us to use memdup_user instead of kmalloc
>> and copy_form_user,
>>
>> With this new function, we don't have to write 'len' twice, which can lead
>> to typos/mistakes.
>> It also produces smaller code and kernel text.
>>
>> http://lkml.iu.edu/hypermail/linux/kernel/0903.0/02349.html
>
> Right, I understand all that. My question was specifically about the
> following sentence from your patch,
>
>> This is a little bit restricted to reduce false positives
>
> What restriction that reduces false positives are you referring to?

I believe that author means that, with this new function, we don't have 
to write 'len' twice, which can lead to typos/mistakes ....

Let me remove the ambiguous comments and send out the patch again.

Ivan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

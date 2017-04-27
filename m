From: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH v2 0/3] efi: add support for non-standard capsule headers
Date: Thu, 27 Apr 2017 13:46:14 +0100
Message-ID: <d3885f56-8c36-9b94-b653-c14536022129@nexus-software.ie>
References: <cover.1492626781.git.jan.kiszka@siemens.com>
 <20170425150005.GR24360@codeblueprint.co.uk>
 <CAKv+Gu9syA8BNWGOJp+qK_eMNUGS6niB+Ac6KA5aRVLac9NAug@mail.gmail.com>
 <3fe85a2e-c846-5545-7896-c838bec6f251@nexus-software.ie>
 <CAKv+Gu_WXagYAUoWbgwCNnPBynOHMg81HQ=hfyb_X+YarynUxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_WXagYAUoWbgwCNnPBynOHMg81HQ=hfyb_X+YarynUxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25/04/17 16:08, Ard Biesheuvel wrote:
> On 25 April 2017 at 16:07, Bryan O'Donoghue
>> I'm OOO until Thursday however, I could test this out on a Galileo for
>> you with the CSH stripped out. As Jan has pointed out Galileo aka Quark
>> x1000 non-secure (not to be called insecure) will just skips past the
>> CSH anyway - so - we can give it a conformant capsule by stripping the
>> CSH junk off the top.
>>
>> How about you queue it up and I'll let you know if there's a problem
>> Thursday?
>>
>
> That would be highly appreciated, thanks.
>

Looks good.

I stripped the header
dd skip=1024 bs=1 if=firmware.cap of=firmware-no-csh.cap

Downloaded the now conformat capsule and update/reflash succeeded.

---
bod

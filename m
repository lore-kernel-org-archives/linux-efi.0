From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/8] efi: add support for non-standard capsule headers
Date: Tue, 18 Apr 2017 18:28:33 +0200
Message-ID: <5549a89b-6b4c-7b8b-217b-36a2bcc99d7a@siemens.com>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
 <f417e914-7b95-9886-fb8f-bca79d5456a3@nexus-software.ie>
 <CAKv+Gu9b7ELU4RtcojrSwCmZg8p-oqXzmdTSVqzAhma1Rg+jQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9b7ELU4RtcojrSwCmZg8p-oqXzmdTSVqzAhma1Rg+jQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2017-04-18 18:23, Ard Biesheuvel wrote:
> On 18 April 2017 at 17:26, Bryan O'Donoghue
> <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org> wrote:
>>
>>
>> On 05/04/17 10:23, Ard Biesheuvel wrote:
>>>
>>> This is a followup to Jan's series [0] to add support for the non-standard
>>> and awkward capsule header layout that is used by the Quark platform.
>>>
>>> While we would prefer to adhere to the standard rigorously, the reality
>>> (and common practice) in Linux is that we sometimes have to deal with
>>> quirks. So while Jan's aim is to get Quark to work, the reason for my
>>> involvement is to try and accommodate this in a flexible way without
>>> putting any handling specific to this quirk in the common code.
>>
>>
>> Hi Ard, Jan.
>>
>> I've run this series on my Galileo Gen2 and it appears to work well.
>>
>> Please take my;
>>
>> Tested-by: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
>>
> 
> Thanks Bryan,
> 
> I take it this is a board that is affected by the quirk?
> 

The Galileo Gen2 firmware doesn't technically require the CSH for
flashing (there is no secure boot with its SoC variant, thus no
verification of the header), but it can swallow such an update format.
It's a third case, so to say.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux

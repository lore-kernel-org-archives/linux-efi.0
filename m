From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [PATCH v2 0/3] efi: add support for non-standard capsule headers
Date: Tue, 25 Apr 2017 16:07:21 +0100
Message-ID: <3fe85a2e-c846-5545-7896-c838bec6f251@nexus-software.ie>
References: <cover.1492626781.git.jan.kiszka@siemens.com>
 <20170425150005.GR24360@codeblueprint.co.uk>
 <CAKv+Gu9syA8BNWGOJp+qK_eMNUGS6niB+Ac6KA5aRVLac9NAug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9syA8BNWGOJp+qK_eMNUGS6niB+Ac6KA5aRVLac9NAug@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, Hock Leong Kweh <hock.leong.kweh@intel.com>, Borislav Petkov <bp@alien8.de>, Sascha Weisenberger <sascha.weisenberger@siemens.com>
List-Id: linux-efi@vger.kernel.org

On 25/04/17 16:01, Ard Biesheuvel wrote:
> On 25 April 2017 at 16:00, Matt Fleming <matt@codeblueprint.co.uk> wrote:
>> On Wed, 19 Apr, at 08:32:59PM, Jan Kiszka wrote:
>>> This picks up the patches Ard send before in [1], including the
>>> "left-over" patches 6..8.
>>>
>>> As Ard suggested, I've taken updated patches 6 and 7 of him from [2]
>>> which address reviewer comments. Furthermore, I've changed patch 8 to
>>> factor out the Quark quirk logic from the overloaded
>>> efi_capsule_setup_info as requested by Matt and also applied Andy's
>>> suggestion to have a quirk dispatcher table with callbacks.
>>>
>>> Tested successfully on the IOT2040 - still without a working Galileo
>>> board.
>>>
>>> Jan
>>>
>>> [1] http://www.spinics.net/lists/linux-efi/msg11194.html
>>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=quark-capsule
>>>
>>> Cc: Matt Fleming <matt@codeblueprint.co.uk>
>>>
>>> Ard Biesheuvel (2):
>>>   efi/capsule-loader: Redirect calls to efi_capsule_setup_info via weak
>>>     alias
>>>   efi/capsule-loader: Use page addresses rather than struct page
>>>     pointers
>>>
>>> Jan Kiszka (1):
>>>   efi/capsule: Add support for Quark security header
>>>
>>>  arch/x86/platform/efi/quirks.c        | 137 ++++++++++++++++++++++++++++++++++
>>>  drivers/firmware/efi/Kconfig          |   9 +++
>>>  drivers/firmware/efi/capsule-loader.c |  66 ++++++++--------
>>>  drivers/firmware/efi/capsule.c        |   7 +-
>>>  include/linux/efi.h                   |  14 +++-
>>>  5 files changed, 197 insertions(+), 36 deletions(-)
>>
>> OK, this looks like it's in good shape to me.
>>
>> Ard, are we waiting for anything else before we queue this up for
>> v4.13?
> 
> Ideally, we'd get someone to test it with compliant capsule headers,
> but I'm happy to just queue it for v4.13, and get it in -next asap
> (i.e., right after the merge window closes)
> 

I'm OOO until Thursday however, I could test this out on a Galileo for
you with the CSH stripped out. As Jan has pointed out Galileo aka Quark
x1000 non-secure (not to be called insecure) will just skips past the
CSH anyway - so - we can give it a conformant capsule by stripping the
CSH junk off the top.

How about you queue it up and I'll let you know if there's a problem
Thursday?

-- 
bod

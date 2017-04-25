From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/3] efi: add support for non-standard capsule headers
Date: Tue, 25 Apr 2017 16:01:49 +0100
Message-ID: <CAKv+Gu9syA8BNWGOJp+qK_eMNUGS6niB+Ac6KA5aRVLac9NAug@mail.gmail.com>
References: <cover.1492626781.git.jan.kiszka@siemens.com> <20170425150005.GR24360@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170425150005.GR24360-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 April 2017 at 16:00, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Wed, 19 Apr, at 08:32:59PM, Jan Kiszka wrote:
>> This picks up the patches Ard send before in [1], including the
>> "left-over" patches 6..8.
>>
>> As Ard suggested, I've taken updated patches 6 and 7 of him from [2]
>> which address reviewer comments. Furthermore, I've changed patch 8 to
>> factor out the Quark quirk logic from the overloaded
>> efi_capsule_setup_info as requested by Matt and also applied Andy's
>> suggestion to have a quirk dispatcher table with callbacks.
>>
>> Tested successfully on the IOT2040 - still without a working Galileo
>> board.
>>
>> Jan
>>
>> [1] http://www.spinics.net/lists/linux-efi/msg11194.html
>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=quark-capsule
>>
>> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>>
>> Ard Biesheuvel (2):
>>   efi/capsule-loader: Redirect calls to efi_capsule_setup_info via weak
>>     alias
>>   efi/capsule-loader: Use page addresses rather than struct page
>>     pointers
>>
>> Jan Kiszka (1):
>>   efi/capsule: Add support for Quark security header
>>
>>  arch/x86/platform/efi/quirks.c        | 137 ++++++++++++++++++++++++++++++++++
>>  drivers/firmware/efi/Kconfig          |   9 +++
>>  drivers/firmware/efi/capsule-loader.c |  66 ++++++++--------
>>  drivers/firmware/efi/capsule.c        |   7 +-
>>  include/linux/efi.h                   |  14 +++-
>>  5 files changed, 197 insertions(+), 36 deletions(-)
>
> OK, this looks like it's in good shape to me.
>
> Ard, are we waiting for anything else before we queue this up for
> v4.13?

Ideally, we'd get someone to test it with compliant capsule headers,
but I'm happy to just queue it for v4.13, and get it in -next asap
(i.e., right after the merge window closes)

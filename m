From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: make EFI a menuconfig to ease disabling it all
Date: Fri, 15 Dec 2017 17:50:49 +0100
Message-ID: <CAKv+Gu8Jd8Z78_1SrcLvX7DKSxf9BjkJtJ+UXYi7ak_zpA3fKQ@mail.gmail.com>
References: <20171209155252.6403-1-vincent.legoll@gmail.com> <20171215151910.GC3204@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171215151910.GC3204@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Vincent Legoll <vincent.legoll@gmail.com>, Kees Cook <keescook@chromium.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 15 December 2017 at 16:19, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Sat, 09 Dec, at 04:52:52PM, Vincent Legoll wrote:
>> No need to get into the submenu to disable all related
>> config entries.
>>
>> This makes it easier to disable all EFI config options
>> without entering the submenu. It will also enable one
>> to see that en/dis-abled state from the outside menu.
>>
>> This is only intended to change menuconfig UI, not change
>> the config dependencies.
>>
>> Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
>> ---
>>  drivers/firmware/efi/Kconfig | 13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> This looks fine to me. Ard?

Doesn't this break existing configs?

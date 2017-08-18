From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] Enable reset attack mitigation
Date: Fri, 18 Aug 2017 21:19:48 +0100
Message-ID: <CAKv+Gu-DpEfAXjtkeYCe8pL9Un6yBvanJsYVSXtRQZmRa++Arw@mail.gmail.com>
References: <20170804212010.15064-1-mjg59@google.com> <CAKv+Gu89bW5CrddxFan095NK_ZmcCpeG_vzx1BuxJ+z-yj3VGQ@mail.gmail.com>
 <CACdnJuty5W0EPLQvBsM=1ySRwCz5Kh4Ht_brZ5pn9ueyF9fT5A@mail.gmail.com>
 <CAKv+Gu9v5Tv8U3uinMJ=ok2uDM+kTozDNuvsQtsDBZcPBcVXQQ@mail.gmail.com> <CACdnJusFXcJVM+w2JPamjDP2MxRyu1mMVF73V-LusmNGUEmbpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJusFXcJVM+w2JPamjDP2MxRyu1mMVF73V-LusmNGUEmbpg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On 18 August 2017 at 20:57, Matthew Garrett <mjg59@google.com> wrote:
> On Fri, Aug 18, 2017 at 12:29 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 18 August 2017 at 20:08, Matthew Garrett <mjg59@google.com> wrote:
>>> If the kernel doesn't synchronously zero the key when dm-crypt is torn
>>> down, that feels like a bug?
>>
>> Of course it should. But that is not the point. The point is that
>> userland is in no position to decide whether or not memory has been
>> sufficiently cleaned so that the firmware can omit wiping all of it
>> (in case you care enough about your secrets to enable that feature in
>> the first place).
>
> The kernel is in no position to decide whether or not userland has
> disposed of secrets either - at some point you need to trust a
> component, and I have more faith that the kernel will do the right
> thing. The only other option here seems to be a double opt-in (ie,
> have userland assert that it's cleaned up, have the kernel set the
> flag at reset time) but we're still assuming that the kernel is
> behaving correctly, and if we assume that the kernel is behaving
> correctly then we can just let userland set the flag anyway.
>

OK, fair enough.

>> Given that the string 'MemoryOverWriteRequest' does not appear in
>> today's EDK2, I don't suppose there is any urgency wrt getting this
>> queued for v4.14?
>
> It's not implemented in EDK2, but it's in pretty much every vendor
> implementation. All the machines I have here support this already.

OK. I will get it queued. No need to resend, I can apply the fixes locally.

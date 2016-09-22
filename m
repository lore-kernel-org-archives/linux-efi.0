From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: EFI co-maintainer
Date: Thu, 22 Sep 2016 09:49:00 +0100
Message-ID: <CAKv+Gu9bs==cP6a=Gf_VMosvD9M4gwJYF3+1RPPae7w5_OPR5g@mail.gmail.com>
References: <20160921150912.GM2892@codeblueprint.co.uk> <20160921175951.GA3387@wunner.de>
 <20160922083402.GA16071@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160922083402.GA16071@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Lukas Wunner <lukas@wunner.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 22 September 2016 at 09:34, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Wed, 21 Sep, at 07:59:51PM, Lukas Wunner wrote:
>>
>> That is great to hear, thanks a lot from me as well.
>>
>> Just curious, are there any plans to integrate the new repo into
>> linux-next?  It would be great to have testing as early as possible.
>
> Yes, the existing one is also part of linux-next once it gets merged
> into tip. The issue has been that I didn't send pull requests to tip
> frequently enough for that to happen on a regular basis.
>
> Ard has already mentioned that he'd like to see that change.
>

Well, given the recent developments, where architecture support for
arm64 and ARM is essentially in maintenance mode, and new development
is mainly focused on generic EFI features living under
drivers/firmware/efi, it might make sense to stop feeding through tip,
but go directly to Linus (and to -next)

Going straight to -next, but going through tip for actual merging
introduces a disparity that is outside of our control, i.e., patches
sometimes get 'fixed' en route (although, to be fair, this is usually
only commit log or other textual fixes in comments etc), but since it
is our responsibility as EFI maintainers to ensure that what is in
-next is what gets sent to Linus in the merge request, I think we
shouldn't have one without the other.

>> Also, if this isn't too much trouble, would it be possible to merge
>> urgent into next when patches are added in the future?  When I tested
>> my patches during this release cycle, I tried to pull in everything
>> from efi/urgent + efi/next into my development branch but hit some
>> non-trivial merge conflicts in portions of the EFI code I wasn't
>> familiar with.  And ISTR that efi/next was based on 4.7, not 4.8-rc.
>> In the end I just rebased my patches on efi/next, but felt a bit uneasy
>> as I wasn't testing what the code would eventually look like.
>
> This is a fair request. The only reason this hasn't happened in the
> past is that no one has ever asked for it to happen regularly.
>
> 'next' and 'urgent' are intended to be topic branches, and they're
> based on tags that align with their purpose - 'next' is new features
> and needs a stable base and lots of testing time, whereas 'urgent' is
> critical bug fixes and so needs to be based on the latest -rc.
>
> While I don't think it makes sense to merge those branches together,
> using the 'master' branch as the place with all the changes plus the
> merge resolutions sounds fine to me. This is similar to how the tip
> repository is structured.
>
> Would that work?

Works for me.

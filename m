From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 4/5] efi/libstub/tpm: Retrieve TPM event log in 2.0 format
Date: Wed, 13 Feb 2019 15:22:39 +0100
Message-ID: <CAKv+Gu9_AgkDO5+Us0=WyqKKiV3m-Ajdqx3-NyqqN+kazuPXxw@mail.gmail.com>
References: <20190211143052.3128-1-bsz@semihalf.com> <20190211143052.3128-5-bsz@semihalf.com>
 <20190213112640.GI7087@linux.intel.com> <CABLO=+ne=dfrMiqmmxV_xOPt7QKiwSgnmokgod6ZMn4PZeahvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CABLO=+ne=dfrMiqmmxV_xOPt7QKiwSgnmokgod6ZMn4PZeahvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bartosz Szczepanek <bsz@semihalf.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-efi <linux-efi@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, peterhuewe@gmx.de, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, Ingo Molnar <mingo@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Leif Lindholm <leif.lindholm@linaro.org>, Marcin Wojtas <mw@semihalf.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 13 Feb 2019 at 15:21, Bartosz Szczepanek <bsz@semihalf.com> wrote:
>
> On Wed, Feb 13, 2019 at 12:26 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > Collides with Matthew's changes. I want to land those change first
> > because they are almost production ready.
> >
> > Maybe you should consider reviewing those changes to make sure that
> > they make sense to you so that you can build these on top of after
> > these have landed.
>
> Yeah, I think so. Actually, I wasn't aware of Matthew's efforts, as it
> didn't appear on linux-efi mailing list. (On bad, I haven't checked
> linux-integrity.)
>
> At this point, I think it makes more sense to limit this patchset to
> 5/5 patch, which makes TPM event log initialized on ARM platforms.
> Patches 1-4 introduce nothing more than Matthew already did, maybe
> except putting calc_tpm2_event_size to a library instead of making it
> inline. This function has already grown a bit so it may be a better
> approach, but that's nothing to affect functionality.
>
> I'll pull Matthew changes to my tree to confirm operation on ARM
> platforms, if that works fine the only thing to merge would be 5/5 +
> optionally the library change, if we reach agreement on that.
>

Sounds good, and yes, it would be good to cc patches that affect the
EFI subsystem to linux-efi as well.

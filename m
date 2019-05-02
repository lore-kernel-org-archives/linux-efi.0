From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V5 2/4] tpm: Reserve the TPM final events table
Date: Thu, 2 May 2019 09:14:49 +0200
Message-ID: <CAKv+Gu9PF4u=-7QL4e36Q3S5kC4+5Z=yLYHLT9jE+eNY7YUV7A@mail.gmail.com>
References: <20190227202658.197113-1-matthewgarrett@google.com>
 <20190227202658.197113-3-matthewgarrett@google.com> <CAJzaN5pUJoOCz5-ZDSnTb6dbVPuy0QwmFD0CeofAGK+bRQx0og@mail.gmail.com>
 <CACdnJutpBPAX6TOGgs3Ng2v_cC5hAf-3pHThESvjQ9vbvQeVkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJutpBPAX6TOGgs3Ng2v_cC5hAf-3pHThESvjQ9vbvQeVkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: Bartosz Szczepanek <bsz@semihalf.com>, linux-integrity <linux-integrity@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>, Roberto Sassu <roberto.sassu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

(+ Ingo)

On Tue, 30 Apr 2019 at 21:52, Matthew Garrett <mjg59@google.com> wrote:
>
> On Tue, Apr 30, 2019 at 6:07 AM Bartosz Szczepanek <bsz@semihalf.com> wrote:
> >
> > I may be a little late with this comment, but I've just tested these
> > patches on aarch64 platform (from the top of jjs/master) and got
> > kernel panic ("Unable to handle kernel read", full log at the end of
> > mail). I think there's problem with below call to
> > tpm2_calc_event_log_size(), where physical address of efi.tpm_log is
> > passed as (void *) and never remapped:
>
> Yes, it looks like this is just broken. Can you try with the attached patch?

I'm a bit uncomfortable with EFI code that is obviously broken and
untested being queued for the next merge window in another tree.

What is currently queued there? Can we revert this change for the time
being, and resubmit it via the EFI tree for v5.3?

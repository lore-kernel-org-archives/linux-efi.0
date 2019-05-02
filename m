From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V5 2/4] tpm: Reserve the TPM final events table
Date: Thu, 2 May 2019 11:03:08 -0700
Message-ID: <CACdnJuv1vwi7hgyGb-7a0dKfRhwdXTgj2baxO=qzpB_JJ1a9XQ@mail.gmail.com>
References: <20190227202658.197113-1-matthewgarrett@google.com>
 <20190227202658.197113-3-matthewgarrett@google.com> <CAJzaN5pUJoOCz5-ZDSnTb6dbVPuy0QwmFD0CeofAGK+bRQx0og@mail.gmail.com>
 <20190502083240.GJ14532@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190502083240.GJ14532@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Bartosz Szczepanek <bsz@semihalf.com>, linux-integrity <linux-integrity@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>, Roberto Sassu <roberto.sassu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

On Thu, May 2, 2019 at 1:32 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, Apr 30, 2019 at 03:07:09PM +0200, Bartosz Szczepanek wrote:
> > I may be a little late with this comment, but I've just tested these
> > patches on aarch64 platform (from the top of jjs/master) and got
> > kernel panic ("Unable to handle kernel read", full log at the end of
> > mail). I think there's problem with below call to
> > tpm2_calc_event_log_size(), where physical address of efi.tpm_log is
> > passed as (void *) and never remapped:
>
> Not late. This is not part of any PR yet. Thank you for the
> feedback!
>
> Matthew, can you send an updated version of the whole patch set
> with fixes to this issue and also reordering of the includes?

Yes, I'll resend and let's do this again for 5.3.

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH V5 2/4] tpm: Reserve the TPM final events table
Date: Thu, 2 May 2019 11:32:40 +0300
Message-ID: <20190502083240.GJ14532@linux.intel.com>
References: <20190227202658.197113-1-matthewgarrett@google.com>
 <20190227202658.197113-3-matthewgarrett@google.com>
 <CAJzaN5pUJoOCz5-ZDSnTb6dbVPuy0QwmFD0CeofAGK+bRQx0og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJzaN5pUJoOCz5-ZDSnTb6dbVPuy0QwmFD0CeofAGK+bRQx0og@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bartosz Szczepanek <bsz@semihalf.com>
Cc: Matthew Garrett <matthewgarrett@google.com>, linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 30, 2019 at 03:07:09PM +0200, Bartosz Szczepanek wrote:
> I may be a little late with this comment, but I've just tested these
> patches on aarch64 platform (from the top of jjs/master) and got
> kernel panic ("Unable to handle kernel read", full log at the end of
> mail). I think there's problem with below call to
> tpm2_calc_event_log_size(), where physical address of efi.tpm_log is
> passed as (void *) and never remapped:

Not late. This is not part of any PR yet. Thank you for the
feedback!

Matthew, can you send an updated version of the whole patch set
with fixes to this issue and also reordering of the includes?

/Jarkko

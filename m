From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/5] tpm: Copy calc_tpm2_event_size() to TPM library
Date: Wed, 13 Feb 2019 13:18:06 +0200
Message-ID: <20190213111806.GF7087@linux.intel.com>
References: <20190211143052.3128-1-bsz@semihalf.com>
 <20190211143052.3128-2-bsz@semihalf.com>
 <20190213111443.GE7087@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190213111443.GE7087@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bsz@semihalf.com, matthewgarrett@google.com
Cc: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, ard.biesheuvel@linaro.org, tweek@google.com, mingo@kernel.org, hdegoede@redhat.com, leif.lindholm@linaro.org, mw@semihalf.com
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 13, 2019 at 01:14:43PM +0200, Jarkko Sakkinen wrote:
> On Mon, Feb 11, 2019 at 03:30:48PM +0100, bsz@semihalf.com wrote:
> > From: Bartosz Szczepanek <bsz@semihalf.com>
> > 
> > Function to calculate event size in TPM 2.0 log will also be needed in EFI
> > stub. Separate it to library to make it accessible out of TPM character
> > driver.
> > 
> > It will be removed from tpm2.c in subsequent commit.
> > 
> > Signed-off-by: Bartosz Szczepanek <bsz@semihalf.com>
> 
> Collides with Matthew's patch set, which has priority over this because
> it was sent earlier.
> 
> Matthew, what you think of this? Maybe could replace 1/4 with this in
> your patch set? Somehow feels a bit cleaner approach.

 This commit is in any case broken. It leaves two versions of the
 function hanging to the code base.

 /Jarkko

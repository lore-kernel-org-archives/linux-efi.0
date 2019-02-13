From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/5] tpm: Change calc_tpm2_event_size signature
Date: Wed, 13 Feb 2019 13:20:08 +0200
Message-ID: <20190213112008.GG7087@linux.intel.com>
References: <20190211143052.3128-1-bsz@semihalf.com>
 <20190211143052.3128-3-bsz@semihalf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211143052.3128-3-bsz@semihalf.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bsz@semihalf.com
Cc: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, ard.biesheuvel@linaro.org, tweek@google.com, mingo@kernel.org, hdegoede@redhat.com, leif.lindholm@linaro.org, mw@semihalf.com
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 11, 2019 at 03:30:49PM +0100, bsz@semihalf.com wrote:
> From: Bartosz Szczepanek <bsz@semihalf.com>
> 
> Pass tcg_efi_specid_event as an argument instead of tcg_pcr_event, as the
> former is what is actually needed to compute event size. tcg_pcr_event
> structure describes TPM event log header (even though its name), from where
> efispecid can be extracted -- it seems cleaner and less misleading to do it
> out of calc_tpm2_event_size function.
> 
> Also, use ssize_t instead of int for event log size.
> 
> Signed-off-by: Bartosz Szczepanek <bsz@semihalf.com>

Unreviewable without call sites. NAK.

/Jarkko

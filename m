From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 4/5] efi/libstub/tpm: Retrieve TPM event log in 2.0 format
Date: Wed, 13 Feb 2019 13:26:40 +0200
Message-ID: <20190213112640.GI7087@linux.intel.com>
References: <20190211143052.3128-1-bsz@semihalf.com>
 <20190211143052.3128-5-bsz@semihalf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211143052.3128-5-bsz@semihalf.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bsz@semihalf.com
Cc: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, ard.biesheuvel@linaro.org, tweek@google.com, mingo@kernel.org, hdegoede@redhat.com, leif.lindholm@linaro.org, mw@semihalf.com
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 11, 2019 at 03:30:51PM +0100, bsz@semihalf.com wrote:
> From: Bartosz Szczepanek <bsz@semihalf.com>
> 
> Currently, the only way to get TPM 2.0 event log from firmware is to use
> device tree. Introduce efi_retrieve_tpm2_eventlog_2 function to enable
> retrieving it from EFI structures.
> 
> Include lib/tpm.c into EFI stub to calculate event sizes using helper
> function.
> 
> Signed-off-by: Bartosz Szczepanek <bsz@semihalf.com>

Collides with Matthew's changes. I want to land those change first
because they are almost production ready.

Maybe you should consider reviewing those changes to make sure that
they make sense to you so that you can build these on top of after
these have landed.

There is not rush as I already made my v5.1 PR. These will be released
earliest in v5.2.

/Jarkko

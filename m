From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 3/5] tpm: Use library version of calc_tpm2_event_size in
 sysfs code
Date: Wed, 13 Feb 2019 13:22:32 +0200
Message-ID: <20190213112232.GH7087@linux.intel.com>
References: <20190211143052.3128-1-bsz@semihalf.com>
 <20190211143052.3128-4-bsz@semihalf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211143052.3128-4-bsz@semihalf.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bsz@semihalf.com
Cc: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, ard.biesheuvel@linaro.org, tweek@google.com, mingo@kernel.org, hdegoede@redhat.com, leif.lindholm@linaro.org, mw@semihalf.com
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 11, 2019 at 03:30:50PM +0100, bsz@semihalf.com wrote:
> From: Bartosz Szczepanek <bsz@semihalf.com>
> 
> Expect negative values from calc_tpm2_event_size as error codes.
> Pass efispecid instead of event header to calc_tpm2_event_size.
> 
> Also, include tpm library in the build.
> 
> Signed-off-by: Bartosz Szczepanek <bsz@semihalf.com>

Event log uses securityfs, not sysfs.

/Jarkko

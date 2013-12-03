From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
Date: Tue, 3 Dec 2013 18:38:44 +0000
Message-ID: <20131203183844.GA22668@mudshark.cambridge.arm.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
 <1385762712-17043-2-git-send-email-msalter@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1385762712-17043-2-git-send-email-msalter@redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Salter <msalter@redhat.com>
Cc: "matt.fleming@intel.com" <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "patches@linaro.org" <patches@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, "roy.franz@linaro.org" <roy.franz@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

Hi Mark, Roy,

On Fri, Nov 29, 2013 at 10:05:10PM +0000, Mark Salter wrote:
> This patch adds PE/COFF header fields to the start of the Image
> so that it appears as an EFI application to EFI firmware. An EFI
> stub is included to allow direct booting of the kernel Image. Due
> to EFI firmware limitations, only little endian kernels with 4K
> page sizes are supported at this time. Support in the COFF header
> for signed images was provided by Ard Biesheuvel.

I haven't really jumped into this but, whilst I see the use of EFI_STUB on
both arm and arm64, there seems to be some duplication/reinvention between
the two series you've put together.

Maybe I'm just being ignorant, but the stuff in efi-stub.c really looks to
be doing the same thing on both architectures. Would you guys be able to
work to together to produce an independent series containing the common
parts, then add arm/arm64 backends on top of that please? In particular,
factoring out the device-tree parts ensures that we don't introduce subtle
differences between the two architectures when there's no real need to do
so...

...or shout at me because I didn't understand what you were doing!

Cheers,

Will

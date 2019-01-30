From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] efi: arm/arm64: allow SetVirtualAddressMap() to be omitted
Date: Wed, 30 Jan 2019 18:19:48 +0000
Message-ID: <20190130181948.GC18558@fuggles.cambridge.arm.com>
References: <20190126102207.29488-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190126102207.29488-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>, Alexander Graf <agraf@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, james.morse@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Sat, Jan 26, 2019 at 11:22:07AM +0100, Ard Biesheuvel wrote:
> The UEFI spec revision 2.7 errata A section 8.4 has the following to
> say about the virtual memory runtime services:
> 
>   "This section contains function definitions for the virtual memory
>   support that may be optionally used by an operating system at runtime.
>   If an operating system chooses to make EFI runtime service calls in a
>   virtual addressing mode instead of the flat physical mode, then the
>   operating system must use the services in this section to switch the
>   EFI runtime services from flat physical addressing to virtual
>   addressing."

I should probably go RTFM, but what does UEFI say about the attributes of
"flat physical addressing"? The wording above implies to me that it should
act as though the stage-1 MMU is disabled because it's described as an
alternative to virtual addressing.

If we move in a direction where we avoid calling SetVirtualAddressMap() by
default on arm64, isn't there a real threat that this firmware call will no
longer be validated? Do we need to worry about that?

Finally, Bjorn said that SDM850 is unbootable without this change. Why is
that?

Will

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/4] EFI stub: remove -fdata-sections
Date: Tue, 6 Nov 2018 15:22:50 +0100
Message-ID: <CAKv+Gu_PHbT-KGxfFu3k-C8Fj3qJhDf39G0e5JzMAHT15+LmgQ@mail.gmail.com>
References: <20181106133935.GB30658@n2100.armlinux.org.uk>
 <E1gK1aT-0000oL-Nn@rmk-PC.armlinux.org.uk>
 <CAKv+Gu_-Vqa=TXDzmzorjcPVnxqO3BHvvDyJKViHFLCsnhfeEw@mail.gmail.com>
 <20181106142126.GD30658@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181106142126.GD30658@n2100.armlinux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: linux-efi <linux-efi@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 6 November 2018 at 15:21, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Tue, Nov 06, 2018 at 03:11:18PM +0100, Ard Biesheuvel wrote:
>> On 6 November 2018 at 14:40, Russell King <rmk+kernel@armlinux.org.uk> wrote:
>> > Remove -fdata-sections from the EFI stub build as this causes problems
>> > for the ARM decompressor code.
>> >
>> Just out of curiosity: what kind of problems?
>
> I'm afraid I don't remember - these patches are March 2018.  I suspect
> it was a result of a randconfig build failing to link, as I don't have
> any 32-bit ARM configs that have the EFI stub enabled.
>
> In any case, this will break:
>
> #
> # ARM discards the .data section because it disallows r/w data in the
> # decompressor. So move our .data to .data.efistub, which is preserved
> # explicitly by the decompressor linker script.
> #
> STUBCOPY_FLAGS-$(CONFIG_ARM)    += --rename-section .data=.data.efistub
>
> because with -fdata-sections enabled, there is no longer a single .data
> section, but multiple .data.* sections.  Hence, the rename no longer
> works, and all the EFI stub data ends up being discarded by the
> decompressor link stage.
>

Ah, of course, that must be it.

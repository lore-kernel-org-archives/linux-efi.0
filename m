From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] efi: arm64: abort boot on pending SError
Date: Sat, 2 Jul 2016 12:14:42 +0200
Message-ID: <CAKv+Gu-sAc-PRDqVdi2v9G_crx0dXHpxPhswJHgDRVe6caLjRw@mail.gmail.com>
References: <1467385291-9880-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160701152252.GA17071@leverpostej>
 <CAKv+Gu9Pk6xbUUMisAMhd4rpoYHA+wjzrZGkyEUXPdx_TaniVQ@mail.gmail.com>
 <20160701154612.GC17071@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20160701154612.GC17071@leverpostej>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 1 July 2016 at 17:46, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Jul 01, 2016 at 05:31:33PM +0200, Ard Biesheuvel wrote:
>> On 1 July 2016 at 17:22, Mark Rutland <mark.rutland@arm.com> wrote:
>> > On Fri, Jul 01, 2016 at 05:01:30PM +0200, Ard Biesheuvel wrote:
>> >> It is the firmware's job to clear any pending SErrors before entering
>> >> the kernel. On UEFI, we can fail gracefully rather than panic during
>> >> early boot, so check for this condition in the stub.
>> >>
>> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> >
>> > An SError could be triggered either asynchronously by FW, or as a result
>> > of our actions at any point after this, e.g. due to the filesystem
>> > accesses made to load an initrd.
>> >
>> > So in practice, is checking here useful? Have we seen FW with masked but
>> > pending SError at the point we enter the stub rather than that SError
>> > being triggered later,?
>>
>> Yes. EDK2 keeps SError masked throughout its execution by default, and
>> so any condition that triggered an SError up till this point is likely
>> to still be pending, and blow up the kernel as soon as it unmasks it.
>
> Ok.
>
>> > I'm also not sure what this means for CPER, which may use SError to
>> > signal to the OS. It's possible that the UEFI implementation polls
>> > ISR_EL1 itself, and handles SError appropriately internally, or that the
>> > OS can later deal with the SError based on CPER and friends.
>>
>> Currently, the kernel panics on an SError, and so what the kernel
>> should do once we start dealing with them in a more sophisticated way
>> is hypothetical at the moment. Once that code arrives, it may revert
>> this change, but for now, being dropped back into the UEFI shell does
>> sound more appealing than panic early imo.
>
> Logging something while the UART is available is certainly appealing.
>

Not just the UART, the graphical console as well, if the system has one.

> As you say, we can change this later if/when we have more advanced
> SError handling. So modulo my prior comments, I guess this is fine for
> now.
>

OK, thanks.

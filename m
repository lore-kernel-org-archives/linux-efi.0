From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 2/2] efi: arm-stub: Round up FDT allocation to mapping
 size
Date: Mon, 20 Mar 2017 23:40:35 +0000
Message-ID: <CAKv+Gu9heMeechSf7y2w_5ZSNG4AXjZMASnRQM1tNTpvypM97Q@mail.gmail.com>
References: <1486676573-19237-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486676573-19237-2-git-send-email-ard.biesheuvel@linaro.org>
 <CAOZdJXVrpKQOigp9uDMJ=wW=j_y4XzNf+Ham9huFUTbc6UxDSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAOZdJXVrpKQOigp9uDMJ=wW=j_y4XzNf+Ham9huFUTbc6UxDSw@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Timur Tabi <timur@codeaurora.org>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 20 March 2017 at 23:25, Timur Tabi <timur@codeaurora.org> wrote:
> On Thu, Feb 9, 2017 at 3:42 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> The FDT is mapped via a fixmap entry that is at least 2 MB in size and
>> 2 MB aligned on 4 KB page size kernels.
>>
>> On UEFI systems, the FDT allocation may share this 2 MB block with a
>> reserved region, or another memory region that we should never map,
>> unless we account for this in the size of the allocation (the alignment
>> is already 2 MB)
>>
>> So instead of taking guesses at the needed space, simply allocate 2 MB
>> immediately. The allocation will be recorded as a EFI_LOADER_DATA, and
>> the kernel only memblock_reserve()'s the actual size of the FDT, so the
>> unused space will be released to the kernel.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> This patch is over a month old, and it's been reviewed and tested.  We
> really need this in 4.11.  Please get this merged into 4.11-rc4.
>

We never queue non-critical changes right before the merge window
opens, so it was queued for v4.12 instead.

If it is so important that this ends up in v4.11, you should have
mentioned this at the time, or over the course of the past four weeks.

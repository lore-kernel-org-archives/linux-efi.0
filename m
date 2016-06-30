From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/5] arm64: avoid block entries that we need to split later
Date: Thu, 30 Jun 2016 18:16:31 +0200
Message-ID: <CAKv+Gu_2Sko-rK6GQbfZ3fMZ3UjXbGk2VxK-UFvF8mv-61pUfw@mail.gmail.com>
References: <1467204690-10790-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160630161317.GC26679@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20160630161317.GC26679@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 30 June 2016 at 18:13, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Wed, Jun 29, 2016 at 02:51:25PM +0200, Ard Biesheuvel wrote:
>> Ard Biesheuvel (4):
>>   arm64: mm: add param to force create_pgd_mapping() to use page
>>     mappings
>>   arm64: efi: always map runtime services code and data regions down to
>>     pages
>>   arm64: efi: avoid block mappings for unaligned UEFI memory regions
>>   arm64: mm: fold init_pgd() into __create_pgd_mapping()
>>
>> Catalin Marinas (1):
>>   arm64: mm: Remove split_p*d() functions
>
> I plan to queue these patches for 4.8. Do you have any other patches
> based on these so that I need to create a separate branch? Otherwise,
> I'll just push them on top of arm64 for-next/core branch.
>

No, they can go right on top of arm64/for-next/core AFAICT

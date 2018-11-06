From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/4] arm/efi: fix memblock reallocation crash due to
 persistent reservations
Date: Tue, 6 Nov 2018 20:01:51 +0100
Message-ID: <CAKv+Gu9MNHy4MQ=vBd_4v50gx+TgrqUO7w4J+QLoAWEVrJiSDA@mail.gmail.com>
References: <20181106113732.16351-1-ard.biesheuvel@linaro.org>
 <326d242e-e51b-c11f-8364-390d991488a6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <326d242e-e51b-c11f-8364-390d991488a6@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, linux-efi <linux-efi@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 6 November 2018 at 19:27, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Hi Ard,
>
> On 06/11/18 11:37, Ard Biesheuvel wrote:
>> This series addresses the kexec/kdump crash on arm64 system with many CPUs
>> that was reported by Bhupesh.
>>
>> Patches #1 and #2 fix the actual crash. Patches #3 and #4 optimize the
>> EFI persistent memreserve infrastructure so that fewer memblock reservations
>> are required.
>>
>> Ard Biesheuvel (4):
>>   arm64: memblock: don't permit memblock resizing until linear mapping
>>     is up
>>   efi/arm: defer persistent reservations until after paging_init()
>>   efi: permit multiple entries in persistent memreserve data structure
>>   efi: reduce the amount of memblock reservations for persistent
>>     allocations
>>
>>  arch/arm/kernel/setup.c                 |  1 +
>>  arch/arm64/kernel/setup.c               |  1 +
>>  arch/arm64/mm/init.c                    |  2 -
>>  arch/arm64/mm/mmu.c                     |  2 +
>>  drivers/firmware/efi/efi.c              | 59 ++++++++++++++------
>>  drivers/firmware/efi/libstub/arm-stub.c |  2 +-
>>  include/linux/efi.h                     | 23 +++++++-
>>  7 files changed, 68 insertions(+), 22 deletions(-)
>
> I've just given these patches a go a a TX2 box (one of the 224 CPU
> ones...), and kexec worked just fine (v4.20-rc1 vanilla didn't manage to
> kexec on this box).
>
> There seem to be some additional userspace patches that are required for
> the ACPI tables not to be corrupted in the secondary kernel, but that's
> an orthogonal issue.
>
> Feel free to add
>
> Tested-by: Marc Zyngier <marc.zyngier@arm.com>
>

Thanks Marc.

Any thoughts on whether patches #3 and #4 should be included as fixes?
I'm leaning towards yes.

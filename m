From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 14/32] x86: mm: Provide support to use memblock
 when spliting large pages
Date: Fri, 17 Mar 2017 12:03:31 +0100
Message-ID: <78c99889-f175-f60f-716b-34a62203418a@redhat.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846771545.2349.9373586041426414252.stgit@brijesh-build-machine>
 <20170310110657.hophlog2juw5hpzz@pd.tnic>
 <cb6a9a56-2c52-d98d-3ff6-3b61d0e5875e@amd.com>
 <20170316182836.tyvxoeq56thtc4pd@pd.tnic>
 <ec134379-6a48-905c-26e4-f6f2738814dc@redhat.com>
 <20170317101737.icdois7sdmtutt6b@pd.tnic>
 <b6f9f46c-58c4-a19c-4955-2d07bd411443@redhat.com>
 <20170317105610.musvo4baokgssvye@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170317105610.musvo4baokgssvye@pd.tnic>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Borislav Petkov <bp@suse.de>
Cc: linux-efi@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, linux-pci@vger.kernel.org, linus.walleij@linaro.org, gary.hook@amd.com, linux-mm@kvack.org, hpa@zytor.com, cl@linux.com, tglx@linutronix.de, aarcange@redhat.com, sfr@canb.auug.org.au, mchehab@kernel.org, simon.guinot@sequanux.org, bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org, peterz@infradead.org, piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com, dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, luto@kernel.org, bhelgaas@google.com, dan.j.williams@intel.com, andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au, paul.gortmaker@windriver.com, devel@linuxdriverproject.org
List-Id: linux-efi@vger.kernel.org



On 17/03/2017 11:56, Borislav Petkov wrote:
>> Theoretically or practically?
> In the sense, it needs to be tried first to see how ugly it can get.
> 
>> It only looks at the E820 map, doesn't it?  Why does it have to do
>> anything with percpu memory areas?
> That's irrelevant. What we want to do is take what's in init_mm.pgd and
> modify it. And use the facilities in arch/x86/mm/init_{32,64}.c because
> they already know about early/late pagetable pages allocation and they
> deal with the kernel pagetable anyway.

If it is possible to do it in a fairly hypervisor-independent manner,
I'm all for it.  That is, only by looking at AMD-specified CPUID leaves
and at kernel ELF sections.

Paolo

> And *not* teach pageattr.c about memblock because that can be misused,
> as tglx pointed out on IRC.

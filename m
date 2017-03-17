From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 29/32] kvm: svm: Add support for SEV DEBUG_DECRYPT
 command
Date: Fri, 17 Mar 2017 12:09:42 +0100
Message-ID: <ca24bbc2-25cf-a5ca-cd39-5862036214bb@redhat.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846789744.2349.167641684941925238.stgit@brijesh-build-machine>
 <4579cfdd-1797-8b47-8e00-254e3f6eb73f@redhat.com>
 <d89ef60d-a97c-b712-fb0f-0242ebebb91a@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <d89ef60d-a97c-b712-fb0f-0242ebebb91a@amd.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Brijesh Singh <brijesh.singh@amd.com>, simon.guinot@sequanux.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, linux-pci@vger.kernel.org, linus.walleij@linaro.org, gary.hook@amd.com, linux-mm@kvack.org, paul.gortmaker@windriver.com, hpa@zytor.com, cl@linux.com, dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org, peterz@infradead.org, piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com, bp@suse.de, dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, luto@kernel.org, devel@linuxdriverproject.org, bhelgaas@google.com, tglx@linutronix.de, mcheha
List-Id: linux-efi@vger.kernel.org



On 16/03/2017 19:41, Brijesh Singh wrote:
>>
>> Please do add it, it doesn't seem very different from what you're doing
>> in LAUNCH_UPDATE_DATA.  There's no need for a separate
>> __sev_dbg_decrypt_page function, you can just pin/unpin here and do a
>> per-page loop as in LAUNCH_UPDATE_DATA.
> 
> I can certainly add support to handle crossing the page boundary cases.
> Should we limit the size to prevent user passing arbitrary long length
> and we end up looping inside the kernel? I was thinking to limit to a
> PAGE_SIZE.

I guess it depends on how it's used.  PAGE_SIZE makes sense since you
only know if a physical address is encrypted when you reach it from a
visit of the page tables.

Paolo

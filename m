From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 14/32] x86: mm: Provide support to use memblock
 when spliting large pages
Date: Thu, 16 Mar 2017 23:25:36 +0100
Message-ID: <ec134379-6a48-905c-26e4-f6f2738814dc@redhat.com>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846771545.2349.9373586041426414252.stgit@brijesh-build-machine>
 <20170310110657.hophlog2juw5hpzz@pd.tnic>
 <cb6a9a56-2c52-d98d-3ff6-3b61d0e5875e@amd.com>
 <20170316182836.tyvxoeq56thtc4pd@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170316182836.tyvxoeq56thtc4pd@pd.tnic>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, linux-pci@vger.kernel.org, linus.walleij@linaro.org, gary.hook@amd.com, linux-mm@kvack.org, hpa@zytor.com, cl@linux.com, tglx@linutronix.de, aarcange@redhat.com, sfr@canb.auug.org.au, mchehab@kernel.org, simon.guinot@sequanux.org, bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org, peterz@infradead.org, piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com, dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, luto@kernel.org, bhelgaas@google.com, dan.j.williams@intel.com, andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au, paul.gortmaker@windriver.com, labbott@fedo.osuosl.org, devel@linuxdriverproject.org, iamjoonsoo.kim
List-Id: linux-efi@vger.kernel.org



On 16/03/2017 19:28, Borislav Petkov wrote:
> So how hard would it be if the hypervisor allocated that memory for the
> guest instead? It would allocate it decrypted and guest would need to
> access it decrypted too. All in preparation for SEV-ES which will need a
> block of unencrypted memory for the guest anyway...

The kvmclock memory is initially zero so there is no need for the
hypervisor to allocate anything; the point of these patches is just to
access the data in a natural way from Linux source code.

I also don't really like the patch as is (plus it fails modpost), but
IMO reusing __change_page_attr and __split_large_page is the right thing
to do.

Paolo

From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 06/32] x86/pci: Use memremap when walking setup data
Date: Thu, 2 Mar 2017 10:13:10 -0500
Message-ID: <148846759008.2349.8274808454274279039.stgit@brijesh-build-machine>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Sender: owner-linux-mm@kvack.org
To: simon.guinot@sequanux.org, linux-efi@vger.kernel.org, brijesh.singh@amd.com, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, linux-pci@vger.kernel.org, linus.walleij@linaro.org, gary.hook@amd.com, linux-mm@kvack.org, paul.gortmaker@windriver.com, hpa@zytor.com, cl@linux.com, dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org, peterz@infradead.org, piotr.luc@intel.com, mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com, bp@suse.de, dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, luto@kernel.org, devel@linuxdriverproj
List-Id: linux-efi@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The use of ioremap will force the setup data to be mapped decrypted even
though setup data is encrypted.  Switch to using memremap which will be
able to perform the proper mapping.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/pci/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index a4fdfa7..0b06670 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -691,7 +691,7 @@ int pcibios_add_device(struct pci_dev *dev)
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = ioremap(pa_data, sizeof(*rom));
+		data = memremap(pa_data, sizeof(*rom), MEMREMAP_WB);
 		if (!data)
 			return -ENOMEM;
 
@@ -710,7 +710,7 @@ int pcibios_add_device(struct pci_dev *dev)
 			}
 		}
 		pa_data = data->next;
-		iounmap(data);
+		memunmap(data);
 	}
 	set_dma_domain_ops(dev);
 	set_dev_domain_options(dev);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

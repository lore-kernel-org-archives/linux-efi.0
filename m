From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v10 32/38] xen/x86: Remove SME feature in PV guests
Date: Mon, 17 Jul 2017 16:10:29 -0500
Message-ID: <3b605622a9fae5e588e5a13967120a18ec18071b.1500319216.git.thomas.lendacky@amd.com>
References: <cover.1500319216.git.thomas.lendacky@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <cover.1500319216.git.thomas.lendacky@amd.com>
Sender: linux-arch-owner@vger.kernel.org
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, kasan-dev@googlegroups.com
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Rik van Riel <riel@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Dave Young <dyoung@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, "Michael S. Tsirkin" <mst@redhat.com>, Brijesh Singh <brijesh.singh>
List-Id: linux-efi@vger.kernel.org

Xen does not currently support SME for PV guests. Clear the SME CPU
capability in order to avoid any ambiguity.

Cc: <xen-devel@lists.xen.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/xen/enlighten_pv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 290bc5a..df19217 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -263,6 +263,7 @@ static void __init xen_init_capabilities(void)
 	setup_clear_cpu_cap(X86_FEATURE_MTRR);
 	setup_clear_cpu_cap(X86_FEATURE_ACC);
 	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
+	setup_clear_cpu_cap(X86_FEATURE_SME);
 
 	/*
 	 * Xen PV would need some work to support PCID: CR3 handling as well
-- 
1.9.1

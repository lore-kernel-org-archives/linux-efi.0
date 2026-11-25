Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628026;
	b=suGSCPGp4AcnueWq5EsF7wwZIqba3G9KXgpCFlW7ofXYnu8RqJD5RZ7H++U4a8oo51UF
	 N2F4LmTNIB7mLr57+dGcigvAKKQFVcrcK0KUqiHi5E+EtD8Um7XsipIS3I6hhF6IvOXt7
	 R+f4x3n+EYL4vDDsa6U0AmwqNjR8vl/yE0lt4kI7UEpZV+MGpoDjQF55yMjYeq+FR0IOf
	 8M3UgoCqDmidnnVPLFaPw+6PzThP6vRa/7x80L3rF+UdUIQmCBMTWg2JELDIwR3g0yR6O
	 3sMauT9DJrU0QJWMMIndX1WEczk39/GUQXw1+7wu4F06k4Utuci33T1BEAnDT1etQmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628026;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:X-ME-Received:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=n/6bLDuC2MWLlkiw9AxsEw6O8WtH5WMIcohSXIYDu0M=;
	b=iBc9ei6jtXu04zuXDEqjfcR5gPltZou72k6JljkHT39Hi+8K4fTmbYmwbJWCZlBsSDdg
	 p6jE4XAK+Ck+v26dd41n4xWuY2H5fc6C8gkQe6I94nBF7jDCJGaxJVjK2PWBezau0Lgto
	 JtRdcz0+GTIEGdDAkbkaUvw8g5HLAWMxPASeK8aQOCjmfmKtCzZo5cMIFzrBAfpmpTQ3+
	 E2XIhlgBaxTe09a+LrMw9xGNyl3HTeRxpC1stDvVGOiGBHDCrgWJq1E+9uobssv2HjuIu
	 LEu6TDRkNGQE2FIWprk1vV27H5UzkXs09uomnol/s9QYNW5k6ov97ZKtaj6UD0VSCgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="a/qxYY7J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77518606A32C;
	Wed, 25 Nov 2026 17:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a/qxYY7J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDE81F000D0;
	Wed, 25 Nov 2026 17:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795628025;
	bh=n/6bLDuC2MWLlkiw9AxsEw6O8WtH5WMIcohSXIYDu0M=;
	h=From:To:Cc:Subject:Date;
	b=a/qxYY7Jx4KrcgPN7wnFjijIWU7q3OzxEz/YnyGrjKK+wKdSKLXB0JiYZCmn1FEbx
	 KuFrM1k5cvs7x3jXRL5AoInar9bPon5j//iN1LK0CHxMplHitTrTVFUgLBGMK/ZXXu
	 2r+rA/FZqP6CuoT1QEQI1aTeJ3iwP1dLEEgh8xnyWngBWVufuVa43dIFIx8Sr27WF8
	 ULNP2gobeKLxNGEBml9IVoljcPiLkkXe2zBo+X4ngU4qMW2QnZCuZJdqVfAahkfuD/
	 fdsO17cywQi1ZT+UKbdjDVGBUrF/N+L3Gvf8J4VwHcT0KqvTzek2rw/GgQnjdVWPeV
	 Czphq7SKI763g==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 1463B198006A;
	Wed, 25 Nov 2026 12:33:40 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 25 Nov 2026 12:33:42 -0500
X-ME-Sender: <xms:9BsHa8rRwZ-B6dJQd39mb36_IfObKj3ULBUz0osEA8SPOXbM5snwEA>
    <xme:9BsHa0BmVBwiapEMhuUKQ7fl9cA7S8lwQll8ZeGsqSmQ6a01r4dg_ALumhlGRoFWH
    HTqZGW-BqY4arqLQMhitQAu3ZbFIXc_80kcEezB3sXoMRmC81PlFoo0>
X-ME-Received: <xmr:9BsHa6fIg0J2dn0Sfc3E8WBKM7hPXB_i7PX_qRaXMWPCeXRrLqzinpf9oVs>
X-ME-Proxy-Cause: dmFkZTEjneGXuSsh9t8RLA5fj7OcIMpddJIPpUqkcCDk1koCABNj0DB7+xf1dKOxMj9juV
    tF/xhAcgiETRmldAJL4fSnEhurJbuWquoguflFdf5cgOeCJcEe9MP0oUfMBzJ0/hMO7Ail
    h22HXZLf6H0rTSIZ9mjjY3jC09UdkvYKAJS20FoyaRQda/TTQNzNLog6Np+64GF8l9mToz
    q0cauJaKUUBMxe+bwgi1iKWVZ5OkzDj2yLkDwcN6+LwolQ/4feGVmf6XcJ1jZppe/5nEV4
    lJV66d31/jxmkXNOvdRk1UdK2Rzx/cQhOxp+eVwBZfETf9hpDaFDrDiGYe8iHaydo0eaVm
    J+QAX2klsry1H6D4sR5zJV1+nrOT4PUKbqM4OevwQYzQzb7m4PvTN+k63p9NVReNy7kgkL
    QdpCSmburxqhy/hzlKchbRPw7FHgm6h4p9+GX6Vm8Df7P6sKBPOmABxD827xs4jREwniYo
    eT25z3JA8qNMNakVrKso781cLFrnlBRXUCCAqw8gfDhgJE7laynH0C5jmMPacW98WjiLpy
    B8VO6dq/RAj38Whgsiz2yIe0xXSJzHs9N00zF9mdOLURLsgOVAIUlYrmXe5UScBDhMKRwn
    cOi1nnvBHPcVkqDkHS0dHHnu9e9zHg1WZNeZp3iCVFa/8dRzhh5Oc2qMSEJw
X-ME-Proxy: <xmx:9BsHa8IvTYgfK2V5VArj27Edso_U465UskkroKOd_XMs_XdOG6aFbQ>
    <xmx:9BsHayurQ7qvPx5WRFasGvucq6ucyUOxWsNwt_FtHXxK2Y4QVtgi3A>
    <xmx:9BsHa-bgH0VPYcK40-exctqVMUixUrrg_xb2TcZNMiUVwpfFZHp3tQ>
    <xmx:9BsHay24mIwRuAQ6r_oPPnN5Ye6e8gDSzrAFl6tWzB6XLoxyK9YiQw>
    <xmx:9BsHa0URsQasB42Xh2rpLAL_lRXL-cIGxOk9Pna-5bqINz-sv8Bh5i8e>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 12:33:40 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Mike Rapoport <rppt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	linux-efi@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: [PATCH] x86/efi: Handle EFI_UNACCEPTED_MEMORY in do_add_efi_memmap()
Date: Wed, 25 Nov 2026 17:33:36 +0000
Message-ID: <20261125173338.1250080-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The EFI stub reports unaccepted memory to the kernel as E820 RAM.
do_add_efi_memmap() has no case for EFI_UNACCEPTED_MEMORY and adds the
same range again as E820_TYPE_RESERVED. e820__update_table() resolves
the overlap in favour of the reserved type, so the kernel never uses
the range.

do_add_efi_memmap() runs when soft reservation is enabled and the
firmware marks any conventional memory EFI_MEMORY_SP; that takes no
command-line option. It also runs with the add_efi_memmap boot
parameter. A TDX or SEV-SNP guest booted either way loses the memory the
firmware left unaccepted, and it does not show up in MemTotal.

Add unaccepted memory as RAM, as the stub does. Without
CONFIG_UNACCEPTED_MEMORY the kernel cannot accept it, so keep it
reserved there.

Fixes: 745e3ed85f71 ("efi/libstub: Implement support for unaccepted memory")
Reported-by: Mike Rapoport <rppt@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
Build-tested only, with and without CONFIG_UNACCEPTED_MEMORY.

 arch/x86/platform/efi/efi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 5eb96c17883e..f03d5e984f2f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -150,6 +150,12 @@ static void __init do_add_efi_memmap(void)
 		case EFI_PERSISTENT_MEMORY:
 			e820_type = E820_TYPE_PMEM;
 			break;
+		case EFI_UNACCEPTED_MEMORY:
+			if (IS_ENABLED(CONFIG_UNACCEPTED_MEMORY))
+				e820_type = E820_TYPE_RAM;
+			else
+				e820_type = E820_TYPE_RESERVED;
+			break;
 		default:
 			/*
 			 * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE

base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.54.0


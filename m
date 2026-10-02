Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBAC38332A;
	Fri,  2 Oct 2026 23:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983933; cv=fail; b=DBq6QL68dgrzD0bDrOrZTyDLU56H4hAaQfaBdlESnijn54v7dcED4CZ3WUdJNwXlILB9XLYaZtYj429xTedCiRWQjdTxYbM7BHsD1OH8LWZqytWtmVkOlWUqOea0oDeyh+mlG8FAEZ7QFRFvguFMwGTomZwvQbQTY5FwmO0SAHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983933; c=relaxed/simple;
	bh=vIuIYrhJdhndFBYTpVNxF24CEVlccZfuXHcNt3yXuXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AYcE7kNTb/xUcyVIDncGZXN85UZe8+A7n5ctsIRDeHmzbobUmOgG1vcTuAhP/d/8wWlZi1xGyBSYBrx/ggo2fb5gyFOf5CGfx5tJ8Y7s01cYLdIuziBDwVe2zl7t99vQ5BVbWsCu9NhEJJutJcOM5uIUUJyMrZcyey+l+yEDxMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N7xNd2Ad; arc=fail smtp.client-ip=52.101.46.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N7xNd2Ad"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o5ranrqCLXgE5Rah5UBrByt4UNYxa7ErK+87RMFxS2FcYPN+KEGnz9T93zCKnFCsq7bGuKLRqwlhzDuLmC0sQ1ZaIgCeB18LkxFV2jum49LX1UNBQ6JMmRzpV2WOAKAM7SbudP1eAbMwiVmDVyb1c1a/p0PAWVL6tD4aUXbEHGdRcU3EwOzV/gSDF1qUS0U4gpPY/8+a02sAWj9Mij7Bv//8dubAinPwZf4h2Vp/6+apppvnSFJxrdaDCzB5UVxA4rEOBLW8065n+6AOJ5aXHkaw1UFr8V3u73Xw7QSDkyUfTDTKzqC4+Iop6Ucgt7wwkvM19kOXgybSfirltWKjDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnYwpdQaYV8yTZ+Bc7ku3AH2VwC1T3GWJ/8EukkmdV8=;
 b=qUlAZY0EeFy4AB4JIMZYFBOOpzwSG6GEEXVnhYFkVmGn3PWHBPQ42buMsK2ETXFxQXqkVwvS0HGaW2RbtWN2fTvXRL/pOqIe7beoNeYqTtaw4on/cY88e12gCdsBE7A9C7bekC+6dfRTXfE7oAJh8ZL67tYYyNw8iBbXn+xXZa+t096dEjONgOj+IXiBq0m16fuXIwyKw4q2JpqID7h5qGYoFtG2+JpQ/37f+FzWDHQvqMxi8E5A1sIBm0A7jn3wz5Jxqp7DOhGwBiZ7HgaQn8fhr5NYR7Myv2Dsy0EhyxP4Eq2FmYI5N9uPhUSxGnH8bHdsU/QH/bXpXQs4Z8GmQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnYwpdQaYV8yTZ+Bc7ku3AH2VwC1T3GWJ/8EukkmdV8=;
 b=N7xNd2AdCwLPFrI1dQgwkcCyVJMTL9Qs6mTwyD81/QdTCCuaY9NXBDBS5Ta9+ZmZOXG0Kuw91V9e1XYV3zFNwMxCka8ZzU1gJ87btcmciw6WDbWCJQXHYvXnlxIX/wpgawj/twadw4KDJlaTWB/sBpMSmy2Nc7sJg8Unr92nxkhtdKsw4v9B/K17+HV6z8nHBTP8iNnziRyaSSXeRomx5a8SnJ1AAjVSgBO0lGGwvxlBC5ggF7Lti6zk328CPAb4bZ9mChVNv8EiR3Qa9PRWLgI9aUX1RVRn3CKtoz3CdnyJI3ctX5RNVefER4Zi/fiEV+NbbVqkkJ3xml1X0accLQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH7PR12MB5830.namprd12.prod.outlook.com
 (2603:10b6:510:1d5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Fri, 2 Oct
 2026 23:31:58 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0472.016; Fri, 2 Oct 2026
 23:31:58 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Glass <sjg@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nick Terrell <terrelln@fb.com>,
	Will Deacon <will@kernel.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>,
	patches@lists.linux.dev,
	=?utf-8?q?Piotr_Kr=C3=B3l?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: [PATCH v2 02/15] efi/riscv: libstub: Don't set image_size in handle_kernel_image()
Date: Fri,  2 Oct 2026 20:31:39 -0300
Message-ID: <2-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
In-Reply-To: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0011.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::19) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 69df3e5b-829d-4e23-bde3-08df20dd5925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|10067099003|11063799006|6133799003|921020|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dm+we4vJCn6kMxhGoSlcreInNXaiYcua9jt/K9GnAmjbnm4aDFQsAvCOtOj0yyAqi9OOVzZ+YZs/ZaMfgodGK+FxD3f8pBKCfzE5hyHD3mGOewpocXizs9Uf3J67uRu1EG94UdNfOo9Yn8PeQ7+PuZEgiGi2fSzRtIjbR8CEyKPH10Zdqg0T31OxR2Cs9scWSvkHRusDnqZH+SRWqnDs+/27Tz6JI0CmXMrXbbLrJafAYRGynZPmDt1uLTurGs1YOJwJEx5QZB++U0M2RnpNS0reUlZugJYdZZZryNOf2ah/o7gsLjZHIm8bpDWJSpetieNocjr/nZCvVrWFSI6MVbXxSTgHvOY77nZMccCF4zgi8XCS547ym+rwMxlTk1VxJjiWiqCunUOJbrzNQ/RkH4qAiMvHg0/Gs6AxfLVG0KpcmYbH7XZw+B1jzmwXhPthPycYtJpupEM7GlR5q53zNU3anBPzqxYp3OmJaeQ7sC7MtL8A1kWxV5BYM4+wiohE4pxxnTcdH+VdIaUGp2pQTmYYgQOA+COuCVBGbInW7EIigk/BZTXE+bxRFtIk5uOjFNE+axRElDrVUMtTbYfDQIpaRKX5y4zskQA6miNt5yFlBMlDiMA9IBZo5eF26dfeaQoMnRs9vLF+yA61RwtoNVafNW49C7B6iwV4LwN9/o/ZlxOKejEKhXux5NBVi5nUZY9/MA1M1riFm7aYLiBXqg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(10067099003)(11063799006)(6133799003)(921020)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U4BQsNhW+vReswS+ktH+7qRc+/3WivOqGxtugC9gABzzLISD4MDRKf58jcnz?=
 =?us-ascii?Q?7p3bNZLsffrhUkpqgs+Ykn+xi8rUbPZip38WhMy5kNBmo6JQWVZj0u+iFh8z?=
 =?us-ascii?Q?0iau78hF1wNhxon17cuJBvbNwPD6p4OAfI2psfWPZOmLTemvB0kGeJ9hutcX?=
 =?us-ascii?Q?zdL/+QPmvfBKwtqF1j5aNo7w4IgLPw4mXjq8/JWCcuB19X+oHsSRRsR/+SLR?=
 =?us-ascii?Q?ocq6Tdj4q+PE+uEpHHwirdHe6BT5GXf2nZkSy28SRT5RbvthdGKFdxyUCF2E?=
 =?us-ascii?Q?pfhewJIZS2RRoQlE/dAmSurH3xGpTHs6NkZowW+MYJD8WIl9jba37bCHoe+x?=
 =?us-ascii?Q?KRQ1cR0vgQFtaQ4zuMzTtkbZ9YeVaSZS1j2ib6zwmn//DjNH2s2+DUoNPvoB?=
 =?us-ascii?Q?hAcCmCRZ9/zTXabJfJXL+IxT6mNtxT4bo7U8GO5kFp5xdb2VSIOQ4m3azplL?=
 =?us-ascii?Q?X/JpnDVf2dT0Lv6bb+APF8Oe/FRAFkT+jE4F761gTqcLxcTvo1NvP8JnA+zH?=
 =?us-ascii?Q?QiETwCTUb0Jk9DpkvHIizD3k6xyBqbPd8WeD6J3XK7mGjqdV+8BbpWM3U8yv?=
 =?us-ascii?Q?F4x4Sazk5R562ab64vTWXHicXhlwHNdRPiTXAAJkZ4Yy8TYbRF0MPJ7EQi30?=
 =?us-ascii?Q?jrNbgySdgNMVJHf/VhYliDlEq4gOqB3RBuTIun5FCqEvHy/MirAIENJvj8n9?=
 =?us-ascii?Q?/mjDSB/x+WW4I2NejXG+g/qE432B/aXM4cEwaAP79/DSjuf+T1F0SIoyohmh?=
 =?us-ascii?Q?cj96vyAuu1xycn/92ZKhJen1Qdrmw1cBUrzFQNRcZbWkxd/TkhYL7BVYbaVU?=
 =?us-ascii?Q?0JutXV804yFeOP4ilgTRQyi/b6gnoiPK2P+N0uQL2LHnGFJYnVvg/URDD+Id?=
 =?us-ascii?Q?eSMxm2MNoshIAOxfAjnRfNMspt/Ut2cDlEOIjrduhvlvrx0UHnMSQ5pWir/5?=
 =?us-ascii?Q?r0BrVz6Uzj8Wr9Ejt1JPxaFAL6ie1cDX1VQnJ1p3up+dHy3hotvi+FDTzjuf?=
 =?us-ascii?Q?Dqvu/m4+aazbIDgtQuCPkNkl9N41HDF/9gmTwMPTr5OsiDy+RC4wGyfMkyty?=
 =?us-ascii?Q?Pw8BrdUPkBvWb/a3To6dohh1avglPUGl6v5vKolmeqKrViVSfVetsXhNMEDt?=
 =?us-ascii?Q?TK/6sOgPVWsAs6WjYSQhWlWf/yOFhtid7imO1u1+D+6TjM9ZetPQBulfeMlG?=
 =?us-ascii?Q?FcAc76vth/uUNHNfcjr1MYSmAuBatvuRMuGsQxa6dcA2YKit2NtYi96d+rkR?=
 =?us-ascii?Q?XxR1cBOrO/LoqnepxGKb9c9rcl5JKGpbY9M1UqCGVkwfa/IU7kb4TR1Rk5f4?=
 =?us-ascii?Q?cv1+SNcWwZu5Be3rH3JYNRb2V5+Kx8nMRecQcvDOuAF+83H64VBaa04OU5PE?=
 =?us-ascii?Q?mQXtIVLXQX9YHe6Uao4X3+1oBzmfgiIzrf5VAxuAna5+MSukz46b5DYTlCwH?=
 =?us-ascii?Q?o03p8D7nOwFSBLyLpxm5SHU1E+T8nj2HrswSQNZdfn4kkyjCushWQC4bPFSF?=
 =?us-ascii?Q?acWdugWKQKTZs2GR0+WoCRQdJRkD7sM78F+03v7qcVF8y6AI78Rz38HKp2k/?=
 =?us-ascii?Q?cjviAQRNwF02U82nFMH5j/gG715Mb4XEKNHvDFyRzS5SXK4D0mSC5FqZdFJ6?=
 =?us-ascii?Q?SA4elzb9YtrmjSvOwF3kdi4Y3cQ4q6W0zMRKcEzV9rCTIAUR1vem9LyOBuFH?=
 =?us-ascii?Q?yC4Lee5+VzHmb+UXmDInnRKwY1ab1IuOjvgYPzojZIEZCnFT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69df3e5b-829d-4e23-bde3-08df20dd5925
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 23:31:56.6096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vw6OxUT3MWedjnfwKvxi/aeQqR+VEUobqQmKJqXM2+Y+bGezG26k1Ii3or0WE/8b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

Sashiko points out the image_size should only be set if image_addr was
reassigned to some allocated memory. If image_size is not zero then the
caller will free the image_addr pointer.

efi_kaslr_relocate_kernel() never works like that, if it changes
image_addr to allocated memory the free is done through reserve_size.

Fixes: b7ac4b8ee73d ("riscv: libstub: Implement KASLR by using generic functions")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/firmware/efi/libstub/riscv-stub.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
index e7d9204baee312..725b634c517919 100644
--- a/drivers/firmware/efi/libstub/riscv-stub.c
+++ b/drivers/firmware/efi/libstub/riscv-stub.c
@@ -37,17 +37,14 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	kernel_codesize = __init_text_end - _start;
 	kernel_memsize = kernel_size + (_end - _edata);
 	*image_addr = (unsigned long)_start;
-	*image_size = kernel_memsize;
-	*reserve_size = *image_size;
+	*reserve_size = kernel_memsize;
 
 	status = efi_kaslr_relocate_kernel(image_addr,
 					   reserve_addr, reserve_size,
 					   kernel_size, kernel_codesize, kernel_memsize,
 					   efi_kaslr_get_phys_seed(image_handle));
-	if (status != EFI_SUCCESS) {
+	if (status != EFI_SUCCESS)
 		efi_err("Failed to relocate kernel\n");
-		*image_size = 0;
-	}
 
 	return status;
 }
-- 
2.43.0


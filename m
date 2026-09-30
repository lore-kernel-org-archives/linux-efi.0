Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013048.outbound.protection.outlook.com [40.107.201.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524A451DE1D;
	Wed, 30 Sep 2026 21:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790805274; cv=fail; b=TNi3fZ2IseDqFTLZ2bqq5PBWiIWjC6aheN2nepGea9HlpQ2r6cCnaVOfLiThpXqRolsOVhUl2ujfF0XzgWfSDtmunHRxmMG4FJOIu1VzHQJpCZl5cpqy/eFVVb/ihOMahvrvotmr5XJXx4D5I7oNBlsz4UpFPYDn25J+vS43dPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790805274; c=relaxed/simple;
	bh=IoNLJdkQFdZjdR9qgC4+xNXeg9J7JP+ZDPzzMjmsXR0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3/RmxIqK2MpjJBwT5WFdfSftNK9xgHvHpoUJSKjCxdD30B5KbjpM2xfnuwUMBB4RiBA3AqEjODS0jp6IPctz3ZhsrMnpVKm3eG9D5RrRFXD70c5QxIiQr94C+k64TvDsMND7tIUiumevQnH4o2+7g02XZ6sWk9yDSpdPL81qX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LNQgccY0; arc=fail smtp.client-ip=40.107.201.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LNQgccY0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jw0Dn4Nc4/kY/cNRqo7s3SEn6GavU8HnYmXwBDXcexzHQL4HwI9gf760isNCbhyMXhnpTYXXblpFAILSLxNpFvejNMuco3gyaWRCCL524eYr+MVUl3YY3o6Rc48SZwsvhenCkQ00BrTD/1s+ttuVTUXtIS2MjoV1FBymLkQ1zbdLSDn5LWRZxsiAA5jdTAmeh3+BZTmefVNkTA3nnDuwgtg+067TSo+mck3+lT9m6AL5FCJcAoJNokaDZ4Dn8qRJRaFKgkAAZ4e4APNvYsllw8GnmZdpVq6JbGS45p2o0hmH90/IrjL9ny4rSx4PCKB54cbGmMzjsuugafwXDXOW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcOqY4Pel09HBXPMhcwHnw+1XkvdEjT127/73eGmgq8=;
 b=UEtI59icNSbbGAsOh1kdVtgZqrdi0ZXjX1rtI/80ink1XGkrAoyRxOrSuQIlWk0xcY/pEaXB+7aUBgCSP7FXSTnHSiwAZy0jadT+QJjzTIjyJsDD4LoLXwghyaz4I3INw/z4U7ijLOWjRbdtGdACUh+YHJRxaeGY2pmSK78OJRkvlgdKSI0a0sHhHYNoYCrPQlbJQavcKU/VDnp4OLe2B0agaQvUkDfyeEhm5WM5dSXlvtnRz6Sce61KnenBoMOIcgud6KLcpEpVLuOnd/ZwuEGSw+0I+z/+VBrS51rNdMbDYYgj9Trs0bKoOUYpkjIUnSLlDpEhWDlF0x6dz9qEiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcOqY4Pel09HBXPMhcwHnw+1XkvdEjT127/73eGmgq8=;
 b=LNQgccY0vYCotn3oWmHT0bQ+VbIML+8XAIrwSc5sgoQh3Lrvq3NNJtzQWEyPxoA1Xu2Gh9azsPURdpyXDLLqMKNGMXs6k3dPmghdKA+EdCzbSdb7c3VSzQM9qheTBn9aAyMtkUIWo4veLhEYp9QtJkKuuaO6ywCOkWsTVL8FJa9QaBBx69VvAhzhvfO8SewiKaSaSAP3ZgdCLJvGYFcD3rP7MExuoqUMq8psn/2HRzdSxKU7IW9XhPxsU3Hr7tfVghA9urx5zw1rLEU3/e8zcTUAyDvuK5KBPU3xHrtisfFtbXKUuzwT5c6ixoYlidguSuyTyO0UU9qmFOj2JbtmEw==
Received: from SN7PR04CA0201.namprd04.prod.outlook.com (2603:10b6:806:126::26)
 by MW4PR12MB6949.namprd12.prod.outlook.com (2603:10b6:303:208::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 21:54:22 +0000
Received: from SA2PEPF00003F66.namprd04.prod.outlook.com
 (2603:10b6:806:126:cafe::3e) by SN7PR04CA0201.outlook.office365.com
 (2603:10b6:806:126::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 21:54:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF00003F66.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 21:54:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 14:54:03 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:54:03 -0700
Received: from nvidia.com (10.127.8.11) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 14:54:01 -0700
Date: Wed, 30 Sep 2026 14:53:59 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
CC: Linux ACPI <linux-acpi@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Sudeep Holla
	<sudeep.holla@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, <linux-efi@vger.kernel.org>, Will Deacon
	<will@kernel.org>, "Joerg Roedel (AMD)" <joro@8bytes.org>, Jaroslav Kysela
	<perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Robin Murphy
	<robin.murphy@arm.com>, David Rhodes <david.rhodes@cirrus.com>, "Richard
 Fitzgerald" <rf@opensource.cirrus.com>, <linux-sound@vger.kernel.org>,
	<patches@opensource.cirrus.com>, Shenghao Ding <shenghao-ding@ti.com>, "Kevin
 Lu" <kevin-lu@ti.com>, Baojun Xu <baojun.xu@ti.com>, Sen Wang <sen@ti.com>
Subject: Re: [PATCH v2 2/5] iommu/arm-smmu-v3: Switch to use
 acpi_bus_get_primary_device()
Message-ID: <ar2E99SG6nJK/Csk@nvidia.com>
References: <4766532.LvFx2qVVIh@rafael.j.wysocki>
 <3636226.QJadu78ljV@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3636226.QJadu78ljV@rafael.j.wysocki>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F66:EE_|MW4PR12MB6949:EE_
X-MS-Office365-Filtering-Correlation-Id: 45b8fb49-1de2-434b-4ab2-08df1f3d61ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|1800799024|7416014|23010399003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+UzUlv4rzrjoBpgt94HZwEwbdi3XapHjLfCeVOqxVn/YTdzqN38xDxUOSjNkA+++vVhLXg/cVcp0rToJReIjdo6TyOGWDOrDrAXGgCf5zFWo3LXky/Zc9HSXYYdStirx0Mh0i4LFeM4IQmvdNjjiLgNh3TwtkHcZ+++W8dEnj06uo1xkx0GsKFkrapexPCEszDpmN5QsUg403/FQ7te6vYHXFFa+XyJLHQ3mM+Xnx3EO1wFru8mUNkkEiYJE7gKLvP/+HY4JkhmLG3+jNBo3xt68N1i4CXzSXRZtRbqQUFrkTm4HZz9l2EV7MFeOcx8U+yA0bsO7ik1xiC4vLN8/L8c6OMRToVoqv8htHX5U8oC9VPr8AYv2aPZIgnQswrwSc/fsRetF4hL3XVT4i3tIk0kx9s7pAqw8ihfhXp1IlNfCjv22yCjJor22RXAgqYF2JwYOFOeEXB5OThvty4o3QpbQMc8Rk2tCFdm0tHT5whWIYUcoE3Cyddg2Uj+xR3jNA3j2vvdhHsnFCWyE+koT+b0HCqdC2XVhxrWEjkDYx3T7v3yLoyVuBUtn/awtOd9EucfN10q7KK7Q+6ScDtQNTCB1qMIHxALacxbE/6Oq6r8gKMtKvZcd2rdVYLDNslS83pCP8LQaSeBHvWnhbP7k+p/6qsygg+VOji6d1z/FulSMUygEN6AtwsRGnDwBsU5AYL8fi1C99T5Y0iiGVawOGw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(1800799024)(7416014)(23010399003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eBjgD+aQuSD39KZLc2fZvdmAOMavwT3wm38oevmw/OP2LGEXvAsEshXdF7PBpfwAyJc3gWPKaJuxLDEtGo8WelYiBQQRgqStY/eNp+bi11sefpCDwly19U/rjeKhX2wQVzP878kxM0ZXvKNFsHTzeQOK6jvoOZMWi5LreqMxh7zmFKGNC4rEA6KmSLc99vUtDJ7YzRlMcW3aZU1q0wDo0b9Veo2gNrC3Ke6B1A1nfzB83AdnvyWA1KSdqnCXEaWDHzDSdd4bDJEgubWKDZNNHbgsfxHxQ4mgNG36sZnjntsolz1MfeNGlJlhiN1Ztr10FvurTVLG+2F4xFVeCf5rUViGw6OxniN/IvZICGK/31AInqEWWAVXUetyuXIA2MHuN76NIU4OvOesel+wGZfaR04RIvLPbt2CL9PlKW886lrM790TzYx7j3MN5uROUikG
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 21:54:20.5165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b8fb49-1de2-434b-4ab2-08df1f3d61ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6949

On Wed, Sep 30, 2026 at 08:43:03PM +0200, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> Replace acpi_get_first_physical_node() that is slated for removal
> with acpi_bus_get_primary_device() that takes a reference to the
> device it is about to return.
> 
> This addresses a potential use-after-free that may occur if the
> device returned by acpi_get_first_physical_node() is removed right
> after dropping its ACPI companion's physical_node_lock in that
> function.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

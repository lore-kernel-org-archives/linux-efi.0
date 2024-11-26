Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694D51D63FD;
	Tue, 26 Nov 2024 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732636440; cv=none; b=fpaJW1wM2npuk/+6GwOfla33Q00TtosTAOgle48CT4ljCw0yS0gcgZ6+G8OBIB2oNZoZBNlDbq8RDeq0Z8VNjpaMWmpCPOZdFQNwaPtXtJkSgXUUU1plXuUsFYvtyn+yXgwDOJVnSw8ArMnEDToYvOOzUp123Uywub94lfnXaVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732636440; c=relaxed/simple;
	bh=hTUjNY9flCkMm0ifGnjcVeEuIXKTPu/PIwoX8TNbBUQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N15w6a5gqBbTQ9yKYkk3YVBJUtYjkLWhGykCfoGHDNdAssJ28r/1HxjOhf4vfd1cyrr/tbFXwK2n71xF0MzKVLZxU9LTkXVd599di1NOCQDQ3kd8Rog4bQ9Kcu/V4eiiiDIqyQ8NOvZsK+14v1Ljr/q0DLVLIdmRE8ElFBZhlqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XyRq14pbmz6FHD8;
	Tue, 26 Nov 2024 23:50:05 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 12CE5140447;
	Tue, 26 Nov 2024 23:53:56 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 26 Nov
 2024 16:53:55 +0100
Date: Tue, 26 Nov 2024 15:53:54 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>, "Terry
 Bowman" <terry.bowman@amd.com>
Subject: Re: [PATCH v3 4/7] acpi/ghes, cxl: Rename cxl_cper_register_work to
 cxl_cper_register_event_work
Message-ID: <20241126155354.00005c9c@huawei.com>
In-Reply-To: <20241119003915.174386-5-Smita.KoralahalliChannabasappa@amd.com>
References: <20241119003915.174386-1-Smita.KoralahalliChannabasappa@amd.com>
	<20241119003915.174386-5-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 19 Nov 2024 00:39:12 +0000
Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:

> Rename cxl_cper_register_work() to cxl_cper_register_event_work() to
> better reflect its purpose of registering CXL Component Events based work
> within the CXL subsystem.
> 
> This rename prepares the codebase to support future patches where
> cxl_cper_register_work() will accept generic pointers for Protocol Error
> workqueue integration.
> 
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


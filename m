Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A41130ACEE;
	Tue, 22 Sep 2026 04:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050796; cv=none; b=C+5nLCxS+2/CsQQzkhlJFiFbln5CcwKNQ4ucuEt3rQ8kmAfaR8EDEL1zIZarep7yDcjp5abn0Kax1+1N6OB7iG3fncHTrwx4hGncZv/u6u7eLD+6K8IWgvd2BOkgxddzUjeN1DEI+sViN3O17lvtYFSBsOKAKAfFdOiS4vJ7300=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050796; c=relaxed/simple;
	bh=H8Sw7e86frpTB8DGnAC8KcCkQBMEmIhrJF2hdj56sGo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ct2vXWNFHYPsWC6xMVJXmfnSkOPbzQqEw7Dsa/+yFJPWTu3B1YmpnqRetbLQ4gCVoxRdx5LVNLqh6RNZXfGqC7fiSBSNV7iVU6h4c1ohB8S1QCYaM4UA6aRPT8Ma3Fs8kBC6xZaw1DOsg+t4MIzVgtyRUytd1nrjV/06K8niX+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccTXWVkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccTXWVkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA701F000FF;
	Tue, 22 Sep 2026 04:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050795;
	bh=H8Sw7e86frpTB8DGnAC8KcCkQBMEmIhrJF2hdj56sGo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ccTXWVkHEb+h1bpy7+9f6lh1K4PvvzccB9NYyOXwkAV54BzWnMLSXLt4k5p/oKlvM
	 nTF0unkDISFj1iCut6TIrk4f84DKJKCn2dyC3glr7l2m1BUmNMeVS8AsFnKzYf+gRO
	 5yBagAwduhM+38NYbYaYIvJKeRIi11XG4+zJnDJjdAuPxMp2ek8hWZMaUKpiQARG4q
	 Cu4KMlT96Z8NvbnmzGUw1KfNaqXAnAeEDhdRMVx68BzpfKjjUffMAC8nLP6d4mOM/r
	 0ylvEv9zRb37RPaO4/kNHR99RovesLc0nvE6pT/c0O6a6AGV2zgivh0tpF3StirQYc
	 AU0ee+eJmj2NA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/4] kho: rename kho_scratch= commandline parameter
 to kho_bootmem=
Reply-To: sashiko-reviews@lists.linux.dev
To: "H. Peter Anvin" <hpa@zytor.com>, "Arnd Bergmann" <arnd@arndb.de>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Baoquan He" <baoquan.he@linux.dev>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Alexander
 Graf" <graf@amazon.com>, "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Rob Herring" <robh@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Saravana
 Kannan" <saravanak@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Jonathan Corbet" <corbet@lwn.net>, "Mike
 Rapoport" <rppt@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, conor+dt@kernel.org, robh@kernel.org, x86@kernel.org, devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20260922041321.233986-5-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
 <20260922041321.233986-5-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 04:19:53 +0000
Message-Id: <20260922041953.CFA701F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> KHO now no longer uses "scratch" to describe the memory areas passed by
> previous kernel. Instead, it calls them boot memory, or bootmem in
> short. Rename the kho_scratch=3D commandline parameter to reflect this
> terminology change.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922041321.2339=
86-1-pratyush@kernel.org?part=3D4


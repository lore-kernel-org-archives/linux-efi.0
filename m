Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021102.outbound.protection.outlook.com [52.101.100.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A2943F4C2;
	Wed, 16 Sep 2026 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544595; cv=fail; b=gTOyyaMX9+eeht0s47A7PvKzvn7CYGJEyiJ60K5LwSsV25sGUpXBQxOoMLcrEl/v2UczlaKXLDAjPOM3Fe/khUzQ6cVNG5T6T/YZCN7mZt44lXSbSOKzo15F2M71mvxCl4ENAfgBnh+6Byj8Hw5yo6s24eTrRqmE18TBRquuGmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544595; c=relaxed/simple;
	bh=/XBF05tZnOMc56yX2/fxGYIua5IpQs2Dg9t8XNiFyyo=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=pCHnhPi40WOKv20lxZHSczfihT+uV1RLtdJJeV6CGOoHXReg22FAzBnK60oTvFu9qaUs66tDIjEDxkbaTTtPdIKG1E3OMUi5K8MV8pD3wKlpmb+SromR3fqBPWqk3Un3wjsba1zwIaRcY/KTqcB5M/V3E/pAHo9nVpKaeG8kLNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=cHpV1+ZR; arc=fail smtp.client-ip=52.101.100.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="cHpV1+ZR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TbHt1n3zySRQfvlGIyk03z+HoezNtSOgPUCTanPiGuCAjB0Y5AHx+9NbHbsXTDp6zw+fBtvGoBLTxszUv13zX0jH8yb6gIQEjIycxWsbjNS+UgzxUffx3jwX/nqHpo6aDZy1FdiRsXMj52i7ccN8xAviU9iCQZPs8bKrx2Lm/uDk5tjKYjqdqJQVxr0JuzvUA6rC9feojHgVnwhY5v1LXyts6ikM4aH+V8KLQcX+l2Jo5F2ww8+e3Y2RxspdFMv53sz4IhueewNEZYqBkLETmiUMqcyv9jkSCaiFjVm/Lj5CPTCSczuCCIXLI8/gf4n3hHMgfVRi+95/UOHng/9mqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YBDxjuOhCIm+gGU+HHAa2pWA+FCSpxxwTwV6nJlKwQ=;
 b=HPAejlxy7yLGorKKjwisR/8s1vkjFbI24IYrLsaJTQNfSmTwLzArFZQimgsaAl+4085MM0wPRfDAq9OuF05qaGj7oW50a5wYvN9DEWN5bABHKjvwQeWontsFkDlhX+giD09EHcYkikODLGiuFfUxHlll3s6SSNdDmel8yLSMWFs91v29vKIGGy947GUEj2Tf8IDEHmuhLvTWcSWKjBfxiQI9J8lfUbuvD7zG0/SGGU/B5Nlexwp8NLK+hM4WxUQs84zbI/2N+AJ7Kh4KwvQsDVwvdyp9Mb54II2miF64P+OXoIH0sCIZ3KydKjmKG1HbxOVZlyiX/+RCC27LKv6eaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YBDxjuOhCIm+gGU+HHAa2pWA+FCSpxxwTwV6nJlKwQ=;
 b=cHpV1+ZRbnI+Dr9jft6gBWb/uUDI5Xd9McZMBL3/nLtBUcaDEtONPJYRZonVolKDH9F/X4C2wyHLKnqevB4g0ypPaIv0M5CPHbjRBBZbGMlnSk5mWjsHGgGoIJGmxqLUxzxRfhB9dC1sufxuZFJ22bOcN6P4v0sAhV6dHpyMpJQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4ab::19)
 by CW1P265MB8420.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:26f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.13; Wed, 16 Sep
 2026 07:42:51 +0000
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1]) by LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1%4]) with mapi id 15.21.0406.012; Wed, 16 Sep 2026
 07:42:49 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 16 Sep 2026 08:42:41 +0100
Message-Id: <DLGKLQ9LJPBG.3QU14CCO1Y6Q@garyguo.net>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Nathan Chancellor"
 <nathan@kernel.org>, "Nicolas Schier" <nsc@kernel.org>, "Nick Desaulniers"
 <ndesaulniers@google.com>, "Bill Wendling" <morbo@google.com>, "Justin
 Stitt" <justinstitt@google.com>, "Masahiro Yamada" <masahiroy@kernel.org>,
 "Alexey Gladkov" <legion@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Arnd Bergmann" <arnd@arndb.de>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Mark Rutland"
 <mark.rutland@arm.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Josh Poimboeuf"
 <jpoimboe@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Jonathan Corbet"
 <corbet@lwn.net>, "Randy Dunlap" <rdunlap@infradead.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>, <linux-kbuild@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
 <linux-riscv@lists.infradead.org>, <linux-arch@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-efi@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-doc@vger.kernel.org>, "Jens Axboe"
 <axboe@kernel.dk>, <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v2 20/21] kbuild: build rust crates in parallel with the
 rest of the build
From: "Gary Guo" <gary@garyguo.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Kees Cook" <kees@kernel.org>
X-Mailer: aerc 0.22.0
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-20-39817ec5db23@kernel.org>
 <202609141133.7CA979C89@keescook> <aqkv9SqIdh0qKPFc@gremlin>
In-Reply-To: <aqkv9SqIdh0qKPFc@gremlin>
X-ClientProxiedBy: LO4P123CA0472.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::9) To LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:4ab::19)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOAP265MB8560:EE_|CW1P265MB8420:EE_
X-MS-Office365-Filtering-Correlation-Id: 33a7bc71-b9bd-4a79-7118-08df13c61b9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|10067099003|18002099003|6133799003|4143699003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	0efAcLjKSZs0H6OPnmEIAnSUgmlBnis60nffkIETUknOAxVN9DQx2ALCeedu9DtBaqYYheg2uPeZdQH4I1VVeOuKcE1HVLGxlZ8Ca+h1nWDvv0anmd2samMyEN+JfNo7UDcjK5v2tlEebf/gYFhZJXBuiS3ZnDsaYC36ne7/rt9NWts2FKU8R73GkBeMEqlCfdO2BduFgiQeZMfJUkDFcVErnbLl9/dUCA1t85nBy1Ot/5Air6pqow1N4olTxkYI0xIW7Cjy83Z6GSzgrYy88HXDwYPuqbV8FWXEK9Jj1qeSI9XQj0LtUU2oOuXrXGozqZr1DvUKd1APK9giYav0mpS8I+XoWVp66CJpTp8ia5ScwozGqFeinupQ3QloVq0Kv4WtD54riy+Vn3w5Ne2SLWtjruqtajv2xMpNbobAtwvXXxOhixR53mgXTKpeyyp92pSyrn2jRHaclPMV+v9wKTTMXfpKoh5VQ2c4mzMygmhOXVb0F8rFwgYtamAwW260J05kGFVnWa3a99ao9VuJJy0twO1h+3Mv3uF1WvS07cmswnlyqWlsXY/Sjpo5fqb7Eqgfw52/2clInS5kgh0BUBNaY9aicWI83KXCg5eMbdUlJCMNS6vpmp2QOrcstDZ2bTkrr7jWJ7YNUNlCeM6IYeYLSNgQT10X6McwpYWt2Lc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(10067099003)(18002099003)(6133799003)(4143699003)(56012099006)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anpBT21UMEg2K2FMTUlqSHlEZnBaTnh3MGc1Ry9KbWNSaDBFUmVZd1plL3N4?=
 =?utf-8?B?V0VPZVRmZERzNktlRjBsbDJBSjR0T055aW10cXJkWDRhQkNxQ0t0TmhZcDdo?=
 =?utf-8?B?ZzJmS2xTRWJGVkdDVEJubXYxcTliYVhMVGc1UEVKSkxjR0NLZVFFZnhyL0pk?=
 =?utf-8?B?Ym00RlYrK3dSRWxUOUdSekQ4dEk3ZWlPRWhKNEorUzIybEJiQzRFc0I4eTBB?=
 =?utf-8?B?M3o2Njlqc3RyQ1h5NW44ZFpzODdYd0xiM0YvbzR6SzYyMVpJeFJ5TXQzN3ht?=
 =?utf-8?B?TkgySHF0TFJPZDlNbFIvdm5yY0ZYZ2lRTnl5WHJNSXAwTHdrNCtCdTRpY0pQ?=
 =?utf-8?B?bldZTDlyWmIwYTE0K2lYNG5kMXZTVUI2eTZITExOS3J2Y0FlZ1phenFCN0Fn?=
 =?utf-8?B?WUtaYXpVYVAwRm8zdC8vN2NWOEx2NERhVW1VUW93RGkwS09ZbTcyNXMyek41?=
 =?utf-8?B?RndYL2dJTFJ0ZnhYWTFZQ3ppS0hnL20yTDQ1M3dkQUZtUTI1OFk1UVNseXdZ?=
 =?utf-8?B?cG1PVjlpTkdFZTdYZ1RRSVl3ZnZGSlAzbi8yNjhvOVY4a1A4TzRDMllaaWlq?=
 =?utf-8?B?OE4vZnlRbVJ1czYxMUxHcCtsU0FUTkdoVW5sK09lME1KTDhTRFRJak9IVXBq?=
 =?utf-8?B?N0JEZ29tUFdPeS9qV3NGRUs5QnpvU3ZvSENCYkliUllwc1pJRklHcHVtR2kv?=
 =?utf-8?B?UzB5ejdIcjJiVnNOS2JFVUQvdU9kZUZJMjRJYUNINVdyd0EyRUJtZmxET3V3?=
 =?utf-8?B?OVZlZ3EwU0R6Z1dvWkdqZ1JySnRNUDZkUlRGQk53djNyL3E1NGVILy9ndWc4?=
 =?utf-8?B?NVlKV0Q5d09lQnBmY3dHVTBXbWFCcVVoVlN2ZjNUUDJzUVFLUXA4YzJYbXdZ?=
 =?utf-8?B?UEd4c1hROVQzdlY2dEJKUk9SK3ZaeHBPd3NmUU9kbFBENjViUmUzZ1N6Y1ZL?=
 =?utf-8?B?UWtRTWtncnk1NDRqck16b1hYUXUwRkR5NG1iUG5ERjlnRVVUMWx6djBzS0Q0?=
 =?utf-8?B?ODVXdzV3bU1BMERXTzlsekxIZzFYVmQvNEFPcnJ5TURoUzU1KzhkeGtGZUIz?=
 =?utf-8?B?dHVnbW9ubTk2b0pveFhBOXJkUWNFaWorWkZ4T3RJWERDWGVZVWc5YnJOa0dv?=
 =?utf-8?B?WXFVWEhLV04yMVYwSFBMczBWazIvdC9NM2U5NFNWSFJIaGlpdE5uTGk2eVZI?=
 =?utf-8?B?WkkzSXlQWW1GbU9LK2xJV3pwVmpYQjZWNzMvRFQwd2dva1JVSk83eTN6aFZs?=
 =?utf-8?B?U0lIMzVjK1gyWjEwZUtCcXF1RHdLREh1THdhRjF6S1Zwcmt3cXVDY25BaktH?=
 =?utf-8?B?OWM1NTBNU1RvaFVWTjFpbFNoZFBybXBid3ZFOTUxaEtNSE81Zk1jNE9iZUJa?=
 =?utf-8?B?RVp2TnMwcGdVY1JPLzBUdis1cTU5RW10U285Q2JwdHZGZWppVXp1Yzh1dkkr?=
 =?utf-8?B?cmw3NEJtV0ExUEVlblkzZkNOTHo2am5HKzA3aEFWUkNycEw0Umw5WTAzRU9t?=
 =?utf-8?B?MkU3d0t6aHBNcEFGbVVUV01SaGJFVUU0QlkraGpUczFNVkZSVmhIT2tTRDFI?=
 =?utf-8?B?b2pnYkd4Y3dXeXNtUEp0eXZmeUQyQXBDQTRNeGZsenJsblg4M0VuTE8rcC8r?=
 =?utf-8?B?bXllL05yWjB4YmRLUFFacmhnTDkyKzB5ODc2bzNZNnZKNzY1MXdOdVZVdmZW?=
 =?utf-8?B?azVXTzJKNUczR054U3FNWmlCYXFNamhMejdSSlhkV00yYjh2cHZ1QXRZcG51?=
 =?utf-8?B?SVYxSFQrcVRIcUlFK0VqeFd2Z3h4SlBsdHM4OUdDVFBrNTVSeGVyeW85Nzk0?=
 =?utf-8?B?ajdpV2pYQmJoSVptZFFHd0lxcW5tUkhSR2VXQjRBakE1VWJ3Yk9PYTBmdW5m?=
 =?utf-8?B?Yk1WcjliOVlibzg3Wjh1OWtsZGl6Z0UzQzEyTXY4TXQvMHFReWloVFBwZ0xn?=
 =?utf-8?B?ZUxmY1l3WW5lLzBqZXAyR21hU05sN1NCUUNaTFIySDllcnRMZWcwYjBjS0NJ?=
 =?utf-8?B?OFJWRllpa1oybEV2azFWMXF4S1pXZzhhSGJlS3FXOWhvdnNBSDJXTU1KOUpI?=
 =?utf-8?B?clJXMGZzbHJ6TlJSZWZ4aUxLbVVjdDI5MGFCYnhHdWpVbTYyeVQ4dXEwUHpP?=
 =?utf-8?B?NVpLU2pWS3U2MkMyU1pEMWNueXRvKzc0Qi9lQXZkS096NmJ5TmVKREFtTjBV?=
 =?utf-8?B?SFhRbytBeXVHOVRjN0ZLc2x1YWFlMWxLcGJrVlR0WFh2ZEc1SG85V2NtYm1E?=
 =?utf-8?B?amdjbjN5UkVwV0xidi9FQ0tDSFQwZSt6cEtyeUVQWE50b3FXQnIzRU9mOEZ4?=
 =?utf-8?Q?LTGTr34OJWIwy2BNht?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a7bc71-b9bd-4a79-7118-08df13c61b9a
X-MS-Exchange-CrossTenant-AuthSource: LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:42:49.8723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mS2Ijo/VLzsu75PkDXsh+naN/jpUaLkDSjvC68+B8bpYEOpQMXNhug4S+gsg51cq0rQx3LWvs9S8UNkphCt3Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P265MB8420

On Tue Sep 15, 2026 at 12:58 PM BST, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 14, 2026 at 11:37:54AM -0700, Kees Cook wrote:
>> On Mon, Sep 14, 2026 at 10:22:19AM +0100, Lorenzo Stoakes (ARM) wrote:
>> > +# Rust code elsewhere in the tree depends upon rust/.
>> > +ifdef CONFIG_RUST
>> > +$(KBUILD_RUST_DIRS): | rust
>> > +endif
>> > [...]
>> > +export KBUILD_RUST_DIRS :=3D drivers lib mm samples
>>
>> Doesn't this make all of drivers/, lib/, mm/ and samples/ wait for rust/=
?
>> That's a lot of stall: drivers/ is most of the tree. I think then a
>> CONFIG_RUST build has most of its C work waiting on the rust chain;
>> only the other top-level directories start early? This didn't create new
>> build delays for those configurations?
>
> Yeah good point.
>
> For a defconfig+rust clean build on 128 threads the other top-level direc=
tories
> were done at ~14s while rust ran to ~18.6s, so there was 4-5 of idle.
>
> However the patch improves things by net -3.9s regardless.
>
> This is really only a big box issue though. With fewer threads the rest o=
f the
> tree takes longer so it has no impact on the build.
>
> (An aside - this kind of trade-off is what the series is all about really=
 - the
>  'serial tail' - i.e. the single threaded stuff that _overlaps_ the end o=
f the
>  build is what slows you down.)
>
> Since this _still_ gives you a significant speed up on bigger boxes, I th=
ink
> it's fine as-is.
>
> The LLM says a fix for this would need significant work - a cross-instanc=
e lock
> and an on-demand rust/ build. So I think best as a follow-up?

If we do it we're basically reinventing a new build system. Not saying that
Kbuild isn't one already :)

Best,
Gary


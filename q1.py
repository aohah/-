import os

def process_nginx_logs(file_path: str, target_date: str):
    domain1_https_count = 0
    total_requests_on_date = 0
    successful_requests_on_date = 0

    if not os.path.exists(file_path):
        return 0, 0.0

    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            
            parts = line.split('"')
            if len(parts) < 6:
                continue
                
            try:
                prefix_part = parts[0]
                
                status_size_part = parts[2].strip().split(' ')
                if not status_size_part:
                    continue
                status_code = int(status_size_part[0])
                
                referer = parts[3]
                
                if referer.startswith("https://domain1.com") or referer.startswith("https://www.domain1.com"):
                    domain1_https_count += 1
                
                start_idx = prefix_part.find('[')
                if start_idx != -1:
                    time_str = prefix_part[start_idx+1:]
                    date_part = time_str.split(':')[0]
                    
                    if date_part == target_date:
                        total_requests_on_date += 1
                        if 200 <= status_code < 400:
                            successful_requests_on_date += 1
                            
            except (ValueError, IndexError):
                continue

    success_ratio = 0.0
    if total_requests_on_date > 0:
        success_ratio = successful_requests_on_date / total_requests_on_date
#   计算 HTTPS 请求有多少个是以 domain1.com 为域名
#   给定—个日期  date  ，根据 HTTP 状态码计算当日  (UTC时间）所有请求中成功的比例
    return domain1_https_count, success_ratio

if __name__ == "__main__":
# 直接调用函数就行了